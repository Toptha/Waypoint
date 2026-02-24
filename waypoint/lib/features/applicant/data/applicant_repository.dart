import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/job_listing_model.dart';
import '../../../models/application_model.dart';
import '../../../core/utils/supabase_provider.dart';

part 'applicant_repository.g.dart';

class ApplicantRepository {
  final SupabaseClient _supabase;

  ApplicantRepository(this._supabase);

  // 1. View Open Jobs
  Future<List<JobListingModel>> getOpenJobs() async {
    final response = await _supabase
        .from('job_listings')
        .select()
        .eq('status', 'open')
        .order('created_at', ascending: false);

    return (response as List).map((json) => JobListingModel.fromJson(json)).toList();
  }

  // 2. Upload Resume to Storage
  // Make sure you've created a bucket in Supabase named "resumes"
  Future<String> uploadResume(File file, String applicantId, String jobId) async {
    final fileExtension = file.path.split('.').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '$applicantId/$jobId-$timestamp.$fileExtension';

    await _supabase.storage.from('resumes').upload(filePath, file);

    return _supabase.storage.from('resumes').getPublicUrl(filePath);
  }

  // 3. Submit Application
  Future<void> submitApplication({
    required String jobId,
    required String applicantId,
    required String resumeUrl,
  }) async {
    await _supabase.from('applications').insert({
      'job_id': jobId,
      'applicant_id': applicantId,
      'resume_url': resumeUrl,
    });
  }

  // 4. View Application Status (My applications)
  Future<List<ApplicationModel>> getMyApplications() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _supabase
        .from('applications')
        .select()
        .eq('applicant_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => ApplicationModel.fromJson(json)).toList();
  }
}

@riverpod
ApplicantRepository applicantRepository(Ref ref) {
  return ApplicantRepository(ref.watch(supabaseClientProvider));
}
