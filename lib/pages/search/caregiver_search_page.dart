import 'package:flutter/material.dart';
import 'package:android_final_project/models/patient_care_model.dart';
import 'package:android_final_project/widgets/search/patient_form.dart';
import 'package:android_final_project/widgets/common/step_indicator.dart';
import 'package:android_final_project/widgets/search/care_info_form.dart';
import 'package:android_final_project/widgets/search/patient_symptoms_form.dart';
import 'package:android_final_project/widgets/search/guardian_info_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CaregiverSearch extends StatefulWidget {
  const CaregiverSearch({super.key});

  @override
  State<CaregiverSearch> createState() => _CaregiverSearchState();
}

class _CaregiverSearchState extends State<CaregiverSearch> {
  int currentStep = 0;
  final int maxSteps = 3;

  // Form data
  final formData = PatientCareData();

  void handleNext() {
    if (currentStep < maxSteps) {
      setState(() {
        currentStep++;
      });
    }
  }

  void handlePrevious() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Future<void> handleSubmit() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      await formData.saveToSupabase(supabase, user.id);

      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('간병인 요청이 성공적으로 등록되었습니다.')),
        );
        // 홈 화면으로 이동
        Navigator.of(context).pushReplacementNamed('/patient-home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('간병인 찾기'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                '환자의 정보를 입력하고 맞춤 케어가 가능한 이력의 간병인을 찾아보세요!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              StepIndicator(currentStep: currentStep),
              const SizedBox(height: 20),
              _buildCurrentStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return PatientForm(
          formData: formData,
          onNext: handleNext,
        );
      case 1:
        return CareInfoForm(
          formData: formData,
          onNext: handleNext,
          onPrevious: handlePrevious,
        );
      case 2:
        return PatientSymptomsForm(
          formData: formData,
          onNext: handleNext,
          onPrevious: handlePrevious,
        );
      case 3:
        return GuardianInfoForm(
            formData: formData,
            onPrevious: handlePrevious,
            onSubmit: handleSubmit);
      default:
        return Container();
    }
  }
}
