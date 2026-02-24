class JobListingModel {
  final String id;
  final String title;
  final String description;
  final String department;
  final String status;
  final DateTime createdAt;

  JobListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.department,
    required this.status,
    required this.createdAt,
  });

  factory JobListingModel.fromJson(Map<String, dynamic> json) {
    return JobListingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      department: json['department'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
