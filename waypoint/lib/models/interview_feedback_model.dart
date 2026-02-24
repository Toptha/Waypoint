class InterviewFeedbackModel {
  final String id;
  final String interviewId;
  final String feedback;
  final int rating;
  final DateTime submittedAt;

  InterviewFeedbackModel({
    required this.id,
    required this.interviewId,
    required this.feedback,
    required this.rating,
    required this.submittedAt,
  });

  factory InterviewFeedbackModel.fromJson(Map<String, dynamic> json) {
    return InterviewFeedbackModel(
      id: json['id'] as String,
      interviewId: json['interview_id'] as String,
      feedback: json['feedback'] as String,
      rating: json['rating'] as int,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
    );
  }
}
