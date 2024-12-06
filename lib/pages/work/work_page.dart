import 'package:flutter/material.dart';
import 'package:android_final_project/models/caregiver_profile_model.dart';
import 'package:android_final_project/widgets/work/basic_info_form.dart';
import 'package:android_final_project/widgets/work/work_experience.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:android_final_project/widgets/common/step_indicator.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  int currentStep = 0;
  final formData = CaregiverProfileData();

  void handleNext() {
    setState(() {
      currentStep++;
    });
  }

  void handlePrevious() {
    setState(() {
      currentStep--;
    });
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
          const SnackBar(content: Text('프로필이 성공적으로 저장되었습니다.')),
        );
        // 홈 화면으로 이동
        Navigator.of(context).pushReplacementNamed('/caregiver-home');
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
        title: const Text('간병인 회원가입'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StepIndicator(currentStep: currentStep, totalSteps: 2),
              //StepIndicator(currentStep: currentStep),
              const SizedBox(height: 24),
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
        return BasicInfoForm(
          formData: formData,
          onNext: handleNext,
        );
      case 1:
        return WorkExperienceForm(
          formData: formData,
          onPrevious: handlePrevious,
          onSubmit: handleSubmit,
        );
      default:
        return Container();
    }
  }
}
