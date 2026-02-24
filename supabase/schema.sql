-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- TABLES
-- ==========================================

-- USERS TABLE
-- Extends the Supabase auth.users table
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    role TEXT NOT NULL CHECK (role IN ('applicant', 'hr', 'interviewer')),
    full_name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- JOB LISTINGS TABLE
CREATE TABLE public.job_listings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    department TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed')),
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- APPLICATIONS TABLE
CREATE TABLE public.applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID REFERENCES public.job_listings(id) ON DELETE CASCADE NOT NULL,
    applicant_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    resume_url TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewing', 'interviewing', 'rejected', 'hired')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(job_id, applicant_id)
);

-- INTERVIEWS TABLE
CREATE TABLE public.interviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID REFERENCES public.applications(id) ON DELETE CASCADE NOT NULL,
    interviewer_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    scheduled_at TIMESTAMPTZ NOT NULL,
    meeting_link TEXT,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- INTERVIEW FEEDBACK TABLE
CREATE TABLE public.interview_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    interview_id UUID REFERENCES public.interviews(id) ON DELETE CASCADE UNIQUE NOT NULL,
    feedback TEXT NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    submitted_at TIMESTAMPTZ DEFAULT NOW()
);

-- NOTIFICATIONS TABLE
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- ROW LEVEL SECURITY (RLS)
-- ==========================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Helper functions to prevent infinite recursion in policies
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT
LANGUAGE sql
SECURITY DEFINER SET search_path = public
AS $$
  SELECT role FROM public.users WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION public.is_interviewer_for_application(app_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.interviews
    WHERE application_id = app_id AND interviewer_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.is_applicant_for_interview(app_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.applications
    WHERE id = app_id AND applicant_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.is_interviewer_for_applicant(target_applicant_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.applications a
    JOIN public.interviews i ON a.id = i.application_id
    WHERE a.applicant_id = target_applicant_id AND i.interviewer_id = auth.uid()
  );
$$;

-- ------------------------------------------
-- Users Policies
-- ------------------------------------------
-- Anyone can read their own profile
CREATE POLICY "Users can view their own profile" ON public.users FOR SELECT USING (auth.uid() = id);
-- HR can view all profiles
CREATE POLICY "HR can view all profiles" ON public.users FOR SELECT USING (public.get_user_role() = 'hr');
-- Interviewers can view profiles of applicants they are interviewing
CREATE POLICY "Interviewers can view assigned applicants" ON public.users FOR SELECT USING (
    public.get_user_role() = 'interviewer' AND public.is_interviewer_for_applicant(id)
);

-- ------------------------------------------
-- Job Listings Policies
-- ------------------------------------------
-- Everyone can view open jobs
CREATE POLICY "Anyone can view open jobs" ON public.job_listings FOR SELECT USING (status = 'open');
-- HR can do everything to jobs
CREATE POLICY "HR full access to jobs" ON public.job_listings FOR ALL USING (public.get_user_role() = 'hr');

-- ------------------------------------------
-- Applications Policies
-- ------------------------------------------
-- Applicants can view their own applications
CREATE POLICY "Applicants can view own applications" ON public.applications FOR SELECT USING (auth.uid() = applicant_id);
-- Applicants can insert their own applications
CREATE POLICY "Applicants can create applications" ON public.applications FOR INSERT WITH CHECK (auth.uid() = applicant_id AND public.get_user_role() = 'applicant');
-- HR full access
CREATE POLICY "HR full access to applications" ON public.applications FOR ALL USING (public.get_user_role() = 'hr');
-- Interviewers can view applications assigned to them
CREATE POLICY "Interviewers can view assigned applications" ON public.applications FOR SELECT USING (
    public.get_user_role() = 'interviewer' AND public.is_interviewer_for_application(id)
);

-- ------------------------------------------
-- Interviews Policies
-- ------------------------------------------
-- Applicants can view their own interviews
CREATE POLICY "Applicants can view own interviews" ON public.interviews FOR SELECT USING (
    public.is_applicant_for_interview(application_id)
);
-- Interviewers can view their assigned interviews
CREATE POLICY "Interviewers can view own assignments" ON public.interviews FOR SELECT USING (interviewer_id = auth.uid());
-- HR full access
CREATE POLICY "HR full access to interviews" ON public.interviews FOR ALL USING (public.get_user_role() = 'hr');

-- ------------------------------------------
-- Interview Feedback Policies
-- ------------------------------------------
-- Interviewers can insert feedback for their own interviews
CREATE POLICY "Interviewers can submit feedback" ON public.interview_feedback FOR INSERT WITH CHECK (
    interview_id IN (SELECT id FROM public.interviews WHERE interviewer_id = auth.uid()) AND
    public.get_user_role() = 'interviewer'
);
-- Interviewers can view their own feedback
CREATE POLICY "Interviewers can view own feedback" ON public.interview_feedback FOR SELECT USING (
    interview_id IN (SELECT id FROM public.interviews WHERE interviewer_id = auth.uid())
);
-- HR can view all feedback
CREATE POLICY "HR can view all feedback" ON public.interview_feedback FOR SELECT USING (public.get_user_role() = 'hr');

-- ------------------------------------------
-- Notifications Policies
-- ------------------------------------------
-- Users can view their own notifications
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT USING (user_id = auth.uid());
-- Users can update (e.g. mark as read) their own notifications
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING (user_id = auth.uid());
-- HR can insert notifications
CREATE POLICY "HR can create notifications" ON public.notifications FOR INSERT WITH CHECK (public.get_user_role() = 'hr');

-- ------------------------------------------
-- Storage (Resumes Bucket) Note
-- ------------------------------------------
-- Reminder: You will also need to manually create a highly secure storage bucket called "resumes" 
-- in the Supabase Dashboard, and set RLS:
-- 1. Applicants can INSERT and SELECT their own files via auth.uid() matching the path.
-- 2. HR and Interviewers can SELECT all files in this bucket natively or through similar policies.
