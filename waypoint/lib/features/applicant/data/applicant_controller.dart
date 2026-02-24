import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/job_listing_model.dart';
import '../../../models/application_model.dart';
import '../../auth/data/auth_repository.dart';
import 'applicant_repository.dart';

part 'applicant_controller.g.dart';

// Riverpod provider for fetching List<JobListingModel>
@riverpod
Future<List<JobListingModel>> openJobs(Ref ref) {
  return ref.read(applicantRepositoryProvider).getOpenJobs();
}

// Riverpod provider for fetching List<ApplicationModel>
@riverpod
Future<List<ApplicationModel>> myApplications(Ref ref) {
  return ref.read(applicantRepositoryProvider).getMyApplications();
}

// Application submission controller state
@riverpod
class ApplicationSubmitController extends _$ApplicationSubmitController {
  @override
  FutureOr<void> build() {}

  Future<void> submitApplication(String jobId, File resumeFile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(applicantRepositoryProvider);
      
      // We know user is loaded due to routing logic
      final userId = ref.read(authRepositoryProvider).currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Upload file to Supabase bucket 'resumes' and get back public URL
      final resumeUrl = await repository.uploadResume(resumeFile, userId, jobId);

      // Submit into public.applications
      await repository.submitApplication(
        jobId: jobId,
        applicantId: userId,
        resumeUrl: resumeUrl,
      );

      // Refresh my applications
      ref.invalidate(myApplicationsProvider);
    });
  }
}
