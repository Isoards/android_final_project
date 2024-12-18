import 'package:flutter/material.dart';
import 'package:android_final_project/models/caregiver_profile_model.dart';

class BasicInfoForm extends StatefulWidget {
  final CaregiverProfileData formData;
  final VoidCallback onNext;

  const BasicInfoForm({
    super.key,
    required this.formData,
    required this.onNext,
  });

  @override
  State<BasicInfoForm> createState() => _BasicInfoFormState();
}

class _BasicInfoFormState extends State<BasicInfoForm> {
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
          initialValue: widget.formData.name,
          decoration: const InputDecoration(
            labelText: '이름*',
            hintText: '홍길동',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => setState(() {
            widget.formData.name = value;
          }),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.formData.birthDate,
          decoration: const InputDecoration(
            labelText: '생년월일*',
            hintText: 'YYYY-MM-DD',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => setState(() {
            widget.formData.birthDate = value;
          }),
        ),
        const SizedBox(height: 16),
        const Text('성별*'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('남성'),
                value: '남성',
                groupValue: widget.formData.gender,
                onChanged: (value) {
                  setState(() {
                    widget.formData.gender = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('여성'),
                value: '여성',
                groupValue: widget.formData.gender,
                onChanged: (value) {
                  setState(() {
                    widget.formData.gender = value;
                  });
                },
              ),
            ),
          ],
        ),
        const Text('내/외국인*'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('내국인'),
                value: '내국인',
                groupValue: widget.formData.nationality,
                onChanged: (value) {
                  setState(() {
                    widget.formData.nationality = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('외국인'),
                value: '외국인',
                groupValue: widget.formData.nationality,
                onChanged: (value) {
                  setState(() {
                    widget.formData.nationality = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (widget.formData.isPersonalInfoValid()) {
                  widget.onNext();
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
