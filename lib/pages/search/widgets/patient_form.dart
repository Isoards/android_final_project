import 'package:flutter/material.dart';
import 'package:android_final_project/models/caregiver_form_data.dart';

class PatientForm extends StatefulWidget {
  final CaregiverFormData formData;
  final VoidCallback onNext;

  const PatientForm({
    super.key,
    required this.formData,
    required this.onNext,
  });

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('환자 정보 입력',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '이름 *',
              hintText: '홍길동',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => widget.formData.patientName = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력해주세요';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '생년월일 *',
              hintText: 'YYYY-MM-DD',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => widget.formData.patientBirthDate = value,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: '키 (cm) *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      widget.formData.patientHeight = int.tryParse(value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: '몸무게 (kg) *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      widget.formData.patientWeight = int.tryParse(value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('성별 *'),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.formData.patientGender == '남성'
                        ? Colors.blue
                        : Colors.grey[300],
                  ),
                  onPressed: () {
                    setState(() {
                      widget.formData.patientGender = '남성';
                    });
                  },
                  child: const Text('남성'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.formData.patientGender == '여성'
                        ? Colors.blue
                        : Colors.grey[300],
                  ),
                  onPressed: () {
                    setState(() {
                      widget.formData.patientGender = '여성';
                    });
                  },
                  child: const Text('여성'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.formData.printPatientInfo(); // 환자 정보만 확인
                  widget.onNext();
                }
              },
              child: const Text('다음'),
            ),
          ),
        ],
      ),
    );
  }
}
