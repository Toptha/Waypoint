import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/interview_model.dart';
import '../../../models/application_model.dart';
import '../../../core/utils/supabase_provider.dart';

part 'interviewer_repository.g.dart';

class InterviewerRepository {
  final SupabaseClient _supabase;

  InterviewerRepository(this._supabase);

  // 1. Fetch assigned interviews
  Future<List<InterviewModel>> getMyInterviews() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _supabase
        .from('interviews')
        .select()
        .eq('interviewer_id', userId)
        .order('scheduled_at', ascending: true);

    return (response as List).map((json) => InterviewModel.fromJson(json)).toList();
  }

  // 2. View Application Details (Specifically the resume)
  Future<ApplicationModel> getApplicationDetails(String applicationId) async {
    final response = await _supabase
        .from('applications')
        .select()
        .eq('id', applicationId)
        .single();
        
    return ApplicationModel.fromJson(response);
  }

  // 3. Submit Evaluation Form
  Future<void> submitFeedback({
    required String interviewId,
    required String feedback,
    required int rating,
  }) async {
    // Insert into feedback table
    await _supabase.from('interview_feedback').insert({
      'interview_id': interviewId,
      'feedback': feedback,
      'rating': rating,
    });

    // Mark interview as completed
    await _supabase.from('interviews').update({'status': 'completed'}).eq('id', interviewId);
  }

  // 4. Check if feedback is locked
  Future<bool> hasSubmittedFeedback(String interviewId) async {
    final response = await _supabase
        .from('interview_feedback')
        .select('id')
        .eq('interview_id', interviewId)
        .maybeSingle();
        
    return response != null;
  }
}

@riverpod
InterviewerRepository interviewerRepository(Ref ref) {
  return InterviewerRepository(ref.watch(supabaseClientProvider));
}
