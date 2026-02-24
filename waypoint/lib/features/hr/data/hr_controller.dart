import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/job_listing_model.dart';
import '../../../models/application_model.dart';
import '../../../models/user_model.dart';
import 'hr_repository.dart';

part 'hr_controller.g.dart';

@riverpod
Future<List<JobListingModel>> allJobs(Ref ref) {
  return ref.read(hrRepositoryProvider).getAllJobs();
}

@riverpod
Future<List<ApplicationModel>> jobApplications(Ref ref, String jobId) {
  return ref.read(hrRepositoryProvider).getApplicationsForJob(jobId);
}

@riverpod
Future<List<UserModel>> availableInterviewers(Ref ref) {
  return ref.read(hrRepositoryProvider).getAvailableInterviewers();
}

@riverpod
class JobCreationController extends _$JobCreationController {
  @override
  FutureOr<void> build() {}

  Future<void> createJob(String title, String description, String department) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(hrRepositoryProvider).createJobListing(
        title: title,
        description: description,
        department: department,
      );
      ref.invalidate(allJobsProvider);
    });
  }
}

@riverpod
class JobUpdateController extends _$JobUpdateController {
  @override
  FutureOr<void> build() {}

  Future<void> updateJobStatus(String jobId, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(hrRepositoryProvider).updateJobStatus(jobId, status);
      ref.invalidate(allJobsProvider);
    });
  }
}

@riverpod
class ApplicationUpdateController extends _$ApplicationUpdateController {
  @override
  FutureOr<void> build() {}

  Future<void> assignInterviewer(String applicationId, String interviewerId, DateTime scheduledAt) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(hrRepositoryProvider).assignInterviewer(
        applicationId: applicationId,
        interviewerId: interviewerId,
        scheduledAt: scheduledAt,
      );
    });
  }
}
