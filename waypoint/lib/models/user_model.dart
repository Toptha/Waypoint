class UserModel {
  final String id;
  final String role;
  final String fullName;

  UserModel({
    required this.id,
    required this.role,
    required this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      role: json['role'] as String,
      fullName: json['full_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'full_name': fullName,
    };
  }

  UserModel copyWith({
    String? id,
    String? role,
    String? fullName,
  }) {
    return UserModel(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
    );
  }
}
