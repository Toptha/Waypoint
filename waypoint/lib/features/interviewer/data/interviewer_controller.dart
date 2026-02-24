import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/interview_model.dart';
import '../../../models/application_model.dart';
import 'interviewer_repository.dart';

part 'interviewer_controller.g.dart';

@riverpod
Future<List<InterviewModel>> myInterviews(Ref ref) {
  return ref.read(interviewerRepositoryProvider).getMyInterviews();
}

@riverpod
Future<ApplicationModel> interviewApplication(Ref ref, String applicationId) {
  return ref.read(interviewerRepositoryProvider).getApplicationDetails(applicationId);
}

@riverpod
Future<bool> interviewFeedbackStatus(Ref ref, String interviewId) {
  return ref.read(interviewerRepositoryProvider).hasSubmittedFeedback(interviewId);
}

@riverpod
class InterviewFeedbackController extends _$InterviewFeedbackController {
  @override
  FutureOr<void> build() {}

  Future<void> submitFeedback({
    required String interviewId,
    required String feedback,
    required int rating,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(interviewerRepositoryProvider).submitFeedback(
        interviewId: interviewId,
        feedback: feedback,
        rating: rating,
      );
      ref.invalidate(myInterviewsProvider);
      ref.invalidate(interviewFeedbackStatusProvider(interviewId));
    });
  }
}
