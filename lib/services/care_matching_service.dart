import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:android_final_project/models/patient_care_model.dart';

class CareMatchingService {
  final SupabaseClient _supabase;

  CareMatchingService(this._supabase);

  Future<PatientCareData?> getCareMatchingInfo(String userId) async {
    try {
      final response = await _supabase
          .from('care_requests')
          .select('''
            *,
            patients!inner(
              guardian_id,
              patient_name,
              patient_birth_date,
              patient_height,
              patient_weight,
              patient_gender
            ),
            symptoms(
              symptom_name,
              is_present
            )
          ''')
          .eq('patients.guardian_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      final patientData = PatientCareData();

      // 환자 정보 설정
      patientData.patientName = response['patients']['patient_name'];
      patientData.patientBirthDate = response['patients']['patient_birth_date'];
      patientData.patientHeight = response['patients']['patient_height'];
      patientData.patientWeight = response['patients']['patient_weight'];
      patientData.patientGender = response['patients']['patient_gender'];

      // 간병 요청 정보 설정
      patientData.diseaseName = response['disease_name'];
      patientData.reservationLocation = response['reservation_location'];
      patientData.locationDetail = response['location_detail'];
      patientData.startDate = DateTime.parse(response['start_date']);
      patientData.endDate = DateTime.parse(response['end_date']);
      patientData.dailyStartTime = response['daily_start_time'];
      patientData.dailyEndTime = response['daily_end_time'];
      patientData.includeWeekends = response['include_weekends'];
      patientData.specialNotes = response['special_notes'];

      // 증상 정보 설정
      final symptoms = response['symptoms'] as List;
      patientData.symptoms = Map.fromEntries(symptoms.map((symptom) => MapEntry(
          symptom['symptom_name'] as String, symptom['is_present'] as bool)));

      return patientData;
    } catch (e) {
      debugPrint('Error fetching care matching info: $e');
      return null;
    }
  }
}
