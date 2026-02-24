class InterviewModel {
  final String id;
  final String applicationId;
  final String interviewerId;
  final DateTime scheduledAt;
  final String? meetingLink;
  final String status;
  final DateTime createdAt;

  InterviewModel({
    required this.id,
    required this.applicationId,
    required this.interviewerId,
    required this.scheduledAt,
    this.meetingLink,
    required this.status,
    required this.createdAt,
  });

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
      id: json['id'] as String,
      applicationId: json['application_id'] as String,
      interviewerId: json['interviewer_id'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      meetingLink: json['meeting_link'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
