class ApplicationModel {
  final String id;
  final String jobId;
  final String applicantId;
  final String resumeUrl;
  final String status;
  final DateTime createdAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.resumeUrl,
    required this.status,
    required this.createdAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      applicantId: json['applicant_id'] as String,
      resumeUrl: json['resume_url'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
