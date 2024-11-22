import 'package:flutter/material.dart';
import 'package:android_final_project/models/patient_care_model.dart';
import 'package:android_final_project/widgets/search/patient_form.dart';
import 'package:android_final_project/widgets/common/step_indicator.dart';
import 'package:android_final_project/widgets/search/care_info_form.dart';
import 'package:android_final_project/widgets/search/patient_symptoms_form.dart';
import 'package:android_final_project/widgets/search/guardian_info_form.dart';

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
          onSubmit: () {
            debugPrint(formData.toString());
          },
        );
      default:
        return Container();
    }
  }
}
