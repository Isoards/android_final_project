import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientCareData {
  String? patientName;
  String? patientBirthDate;
  int? patientHeight;
  int? patientWeight;
  String? patientGender;
  String? diseaseName;
  String? reservationLocation;
  String? locationDetail;
  DateTime? startDate;
  DateTime? endDate;
  String? dailyStartTime;
  String? dailyEndTime;
  bool includeWeekends = false;
  Map<String, bool> symptoms = {};
  String? specialNotes;
  String? guardianName;
  String? relationship;
  List<String> guardianPhones = [];
  String? guardianAddress;
  String? guardianAddressDetail;

  // 데이터를 Map으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'patientBirthDate': patientBirthDate,
      'patientHeight': patientHeight,
      'patientWeight': patientWeight,
      'patientGender': patientGender,
      'diseaseName': diseaseName,
      'reservationLocation': reservationLocation,
      'locationDetail': locationDetail,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'dailyStartTime': dailyStartTime,
      'dailyEndTime': dailyEndTime,
      'includeWeekends': includeWeekends,
      'symptoms': symptoms,
      'specialNotes': specialNotes,
      'guardianName': guardianName,
      'relationship': relationship,
      'guardianPhones': guardianPhones,
      'guardianAddress': guardianAddress,
      'guardianAddressDetail': guardianAddressDetail,
    };
  }

  // Map에서 데이터를 불러오는 생성자
  PatientCareData.fromJson(Map<String, dynamic> json) {
    patientName = json['patientName'];
    patientBirthDate = json['patientBirthDate'];
    patientHeight = json['patientHeight'];
    patientWeight = json['patientWeight'];
    patientGender = json['patientGender'];
    diseaseName = json['diseaseName'];
    reservationLocation = json['reservationLocation'];
    locationDetail = json['locationDetail'];
    startDate =
        json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    dailyStartTime = json['dailyStartTime'];
    dailyEndTime = json['dailyEndTime'];
    includeWeekends = json['includeWeekends'] ?? false;
    symptoms = Map<String, bool>.from(json['symptoms'] ?? {});
    specialNotes = json['specialNotes'];
    guardianName = json['guardianName'];
    relationship = json['relationship'];
    guardianPhones = List<String>.from(json['guardianPhones'] ?? []);
    guardianAddress = json['guardianAddress'];
    guardianAddressDetail = json['guardianAddressDetail'];
  }

  // 기본 생성자
  PatientCareData();

  // 데이터 검증 메서드
  bool isPatientFormValid() {
    return patientName != null &&
        patientName!.isNotEmpty &&
        patientBirthDate != null &&
        patientHeight != null &&
        patientWeight != null &&
        patientGender != null;
  }

  bool isCareInfoFormValid() {
    return diseaseName != null &&
        reservationLocation != null &&
        startDate != null &&
        endDate != null;
  }

  bool isGuardianInfoFormValid() {
    return guardianName != null &&
        guardianName!.isNotEmpty &&
        guardianPhones.isNotEmpty;
  }

  @override
  String toString() {
    return '''
PatientCareData:
  환자 정보:
    - 이름: $patientName
    - 생년월일: $patientBirthDate
    - 키: $patientHeight cm
    - 몸무게: $patientWeight kg
    - 성별: $patientGender
    
  간병 정보:
    - 진단명: $diseaseName
    - 간병 장소: $reservationLocation
    - 상세 주소: $locationDetail
    - 시작일: ${startDate?.toString().split(' ')[0]}
    - 종료일: ${endDate?.toString().split(' ')[0]}
    - 시작 시간: $dailyStartTime
    - 종료 시간: $dailyEndTime
    - 주말 포함: $includeWeekends
    
  증상 정보:
  - 증상: $symptoms
  - 특이사항: $specialNotes
  보호자 정보:
    - 이름: $guardianName
    - 관계: $relationship
    - 연락처: ${guardianPhones.join(', ')}
    - 주소: $guardianAddress
    - 상세 주소: $guardianAddressDetail
    ''';
  }

  // 디버깅을 위한 각 단계별 데이터 확인 메서드들
  void printPatientInfo() {
    debugPrint('''
======= 환자 정보 =======
이름: $patientName
생년월일: $patientBirthDate
키: $patientHeight cm
몸무게: $patientWeight kg
성별: $patientGender
======================
    ''');
  }

  void printCareInfo() {
    debugPrint('''
======= 간병 정보 =======
진단명: $diseaseName
간병 장소: $reservationLocation
상세 주소: $locationDetail
시작일: ${startDate?.toString().split(' ')[0]}
종료일: ${endDate?.toString().split(' ')[0]}
시작 시간: $dailyStartTime
종료 시간: $dailyEndTime
주말 포함: $includeWeekends
======================
    ''');
  }

  void printGuardianInfo() {
    debugPrint('''
======= 보호자 정보 =======
이름: $guardianName
관계: $relationship
연락처: ${guardianPhones.join(', ')}
주소: $guardianAddress
상세 주소: $guardianAddressDetail
======================
    ''');
  }

  Future<void> saveToSupabase(
      SupabaseClient supabase, String guardianId) async {
    try {
      // 환자 정보 저장
      final patientResponse = await supabase
          .from('patients')
          .insert({
            'guardian_id': guardianId,
            'patient_name': patientName,
            'patient_birth_date': patientBirthDate,
            'patient_height': patientHeight,
            'patient_weight': patientWeight,
            'patient_gender': patientGender,
          })
          .select('id')
          .single();

      final patientId = patientResponse['id'];

      // 보호자 상세 정보 저장
      await supabase.from('guardian_details').upsert({
        'user_id': guardianId,
        'address': guardianAddress,
        'address_detail': guardianAddressDetail,
      });

      // 보호자 추가 연락처 저장
      for (String phone in guardianPhones) {
        await supabase.from('guardian_additional_phones').insert({
          'guardian_id': guardianId,
          'phone_number': phone,
          'is_primary': guardianPhones.indexOf(phone) == 0,
        });
      }

      // 간병 요청 정보 저장
      final careRequestResponse = await supabase
          .from('care_requests')
          .insert({
            'patient_id': patientId,
            'disease_name': diseaseName,
            'reservation_location': reservationLocation,
            'location_detail': locationDetail,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'daily_start_time': dailyStartTime,
            'daily_end_time': dailyEndTime,
            'include_weekends': includeWeekends,
            'special_notes': specialNotes,
            'status': 'pending'
          })
          .select('id')
          .single();

      final careRequestId = careRequestResponse['id'];

      // 증상 정보 저장
      for (var entry in symptoms.entries) {
        if (entry.value) {
          // true인 증상만 저장
          await supabase.from('symptoms').insert({
            'care_request_id': careRequestId,
            'symptom_name': entry.key,
            'is_present': true,
          });
        }
      }
    } catch (e) {
      debugPrint('Error saving patient care data: $e');
      rethrow;
    }
  }
}
