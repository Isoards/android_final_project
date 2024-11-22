// lib/pages/signup/personal_info_form.dart

import 'package:flutter/material.dart';
import 'package:android_final_project/models/caregiver_profile_model.dart';

class BasicInfoForm extends StatelessWidget {
  final CaregiverProfileData formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const BasicInfoForm({
    Key? key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '간병인의 기본 정보를 알려주세요',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          initialValue: formData.name,
          decoration: const InputDecoration(
            labelText: '이름*',
            hintText: '홍길동',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => formData.name = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: formData.birthDate,
          decoration: const InputDecoration(
            labelText: '생년월일*',
            hintText: 'YYYY-MM-DD',
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              formData.birthDate = date.toString().split(' ')[0];
            }
          },
          readOnly: true,
        ),
        const SizedBox(height: 16),
        const Text('성별*'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('남성'),
                value: '남성',
                groupValue: formData.gender,
                onChanged: (value) => formData.gender = value,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('여성'),
                value: '여성',
                groupValue: formData.gender,
                onChanged: (value) => formData.gender = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('내/외국인*'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('내국인'),
                value: '내국인',
                groupValue: formData.nationality,
                onChanged: (value) => formData.nationality = value,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('외국인'),
                value: '외국인',
                groupValue: formData.nationality,
                onChanged: (value) => formData.nationality = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: onPrevious,
              child: const Text('이전'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formData.isPersonalInfoValid()) {
                  onNext();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 필수 항목을 입력해주세요.')),
                  );
                }
              },
              child: const Text('다음'),
            ),
          ],
        ),
      ],
    );
  }
}
