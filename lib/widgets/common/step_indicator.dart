import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps; // 총 스텝 수 추가
  final List<String>? stepLabels; // 옵션: 스텝 라벨

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) => Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentStep == index ? Colors.deepPurple : Colors.grey[300],
          ),
          child: Center(
            child: Text(
              stepLabels?.elementAt(index) ?? '${index + 1}',
              style: TextStyle(
                color: currentStep == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
