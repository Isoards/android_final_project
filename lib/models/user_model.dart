class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String gender;
  final DateTime birthDate;
  final String userType;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birth_date']),
      userType: json['user_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'gender': gender,
      'birth_date': birthDate.toIso8601String(),
      'user_type': userType,
    };
  }
}
