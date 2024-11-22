import 'package:flutter/material.dart';

class CaregiverProfileData {
  // 회원가입 기본 정보
  String? email;
  String? password;
  String? phone;

  // 개인 정보
  String? name;
  String? birthDate;
  String? gender;
  String? nationality; // 내/외국인

  // 경력 정보
  String? certification; // 자격증
  List<WorkHistory> workHistories = [];
  String? careerDescription; // 자기소개

  // JSON 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'nationality': nationality,
      'certification': certification,
      'workHistories':
          workHistories.map((history) => history.toJson()).toList(),
      'careerDescription': careerDescription,
    };
  }

  // JSON에서 데이터 불러오기
  CaregiverProfileData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    name = json['name'];
    birthDate = json['birthDate'];
    gender = json['gender'];
    nationality = json['nationality'];
    certification = json['certification'];
    workHistories = (json['workHistories'] as List)
        .map((item) => WorkHistory.fromJson(item))
        .toList();
    careerDescription = json['careerDescription'];
  }

  // 기본 생성자
  CaregiverProfileData();

  // 데이터 검증 메서드
  bool isBasicInfoValid() {
    return email != null &&
        email!.isNotEmpty &&
        password != null &&
        password!.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty;
  }

  bool isPersonalInfoValid() {
    return name != null &&
        name!.isNotEmpty &&
        birthDate != null &&
        gender != null &&
        nationality != null;
  }

  bool isWorkExperienceValid() {
    return certification != null &&
        workHistories.isNotEmpty &&
        careerDescription != null &&
        careerDescription!.isNotEmpty;
  }

  @override
  String toString() {
    return '''
CaregiverProfileData:
  기본 정보:
    - 이메일: $email
    - 전화번호: $phone
    
  개인 정보:
    - 이름: $name
    - 생년월일: $birthDate
    - 성별: $gender
    - 내/외국인: $nationality
    
  경력 정보:
    - 자격증: $certification
    - 경력: ${workHistories.join('\n      ')}
    - 자기소개: $careerDescription
    ''';
  }

  // 디버깅용 메서드들
  void printBasicInfo() {
    debugPrint('''
======= 기본 정보 =======
이메일: $email
전화번호: $phone
======================
    ''');
  }

  void printPersonalInfo() {
    debugPrint('''
======= 개인 정보 =======
이름: $name
생년월일: $birthDate
성별: $gender
내/외국인: $nationality
======================
    ''');
  }

  void printWorkExperience() {
    debugPrint('''
======= 경력 정보 =======
자격증: $certification
경력: ${workHistories.join('\n')}
자기소개: $careerDescription
======================
    ''');
  }
}

// 경력 정보를 위한 보조 클래스
class WorkHistory {
  final String workPlace;
  final String startDate;
  final String endDate;

  WorkHistory({
    required this.workPlace,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'workPlace': workPlace,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory WorkHistory.fromJson(Map<String, dynamic> json) {
    return WorkHistory(
      workPlace: json['workPlace'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  @override
  String toString() {
    return '$workPlace ($startDate ~ $endDate)';
  }
}
