class UserModel {
  final String id;
  final String email;
  final String? username;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    this.createdAt,
  });

  // Supabase JSON 데이터를 UserModel 객체로 변환
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // UserModel 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // 객체 복사본 생성 (상태 업데이트 시 유용)
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
