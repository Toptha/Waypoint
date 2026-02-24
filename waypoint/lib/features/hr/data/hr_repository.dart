import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/job_listing_model.dart';
import '../../../models/application_model.dart';
import '../../../models/user_model.dart';
import '../../../core/utils/supabase_provider.dart';

part 'hr_repository.g.dart';

class HrRepository {
  final SupabaseClient _supabase;

  HrRepository(this._supabase);

  // 1. Manage Job Listings
  Future<List<JobListingModel>> getAllJobs() async {
    final response = await _supabase
        .from('job_listings')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => JobListingModel.fromJson(json)).toList();
  }

  Future<void> createJobListing({
    required String title,
    required String description,
    required String department,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    await _supabase.from('job_listings').insert({
      'title': title,
      'description': description,
      'department': department,
      'created_by': userId,
    });
  }

  Future<void> updateJobStatus(String jobId, String status) async {
    await _supabase.from('job_listings').update({'status': status}).eq('id', jobId);
  }

  // 2. Manage Applications
  Future<List<ApplicationModel>> getApplicationsForJob(String jobId) async {
    final response = await _supabase
        .from('applications')
        .select()
        .eq('job_id', jobId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => ApplicationModel.fromJson(json)).toList();
  }

  Future<void> updateApplicationStatus(String applicationId, String status) async {
    await _supabase.from('applications').update({'status': status}).eq('id', applicationId);
  }

  // 3. Manage Interviewers
  Future<List<UserModel>> getAvailableInterviewers() async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('role', 'interviewer');

    return (response as List).map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> assignInterviewer({
    required String applicationId,
    required String interviewerId,
    required DateTime scheduledAt,
    String? meetingLink,
  }) async {
    await _supabase.from('interviews').insert({
      'application_id': applicationId,
      'interviewer_id': interviewerId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'meeting_link': meetingLink,
    });
    
    // Also update the application status
    await updateApplicationStatus(applicationId, 'interviewing');
  }
}

@riverpod
HrRepository hrRepository(Ref ref) {
  return HrRepository(ref.watch(supabaseClientProvider));
}
