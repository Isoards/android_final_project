import 'package:flutter/material.dart';
import 'package:android_final_project/models/patient_care_model.dart';

class PatientSymptomsForm extends StatefulWidget {
  final PatientCareData formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PatientSymptomsForm({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<PatientSymptomsForm> createState() => _PatientSymptomsFormState();
}

class _PatientSymptomsFormState extends State<PatientSymptomsForm> {
  final _formKey = GlobalKey<FormState>();

  // 환자 상태 체크리스트
  final Map<String, bool> symptoms = {
    '의식 없음': false,
    '마비': false,
    '욕창': false,
    '거동 불편': false,
    '배변 도움 필요': false,
    '식사 도움 필요': false,
    '석션 필요': false,
    '기저귀 착용': false,
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '환자 상태 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 환자 상태 체크리스트
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '환자 상태 체크리스트',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: symptoms.keys.map((symptom) {
                      return FilterChip(
                        label: Text(symptom),
                        selected: symptoms[symptom]!,
                        onSelected: (bool selected) {
                          setState(() {
                            symptoms[symptom] = selected;
                            // formData의 symptoms 맵에도 상태 업데이트
                            widget.formData.symptoms[symptom] = selected;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 특이사항
          TextFormField(
            decoration: const InputDecoration(
              labelText: '특이사항',
              hintText: '환자의 특이사항을 입력해주세요',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              widget.formData.specialNotes = value;
            },
          ),

          const SizedBox(height: 24),

          // 이전/다음 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onPrevious,
                  child: const Text('이전'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // 현재 symptoms 상태를 formData에 저장
                      widget.formData.symptoms.clear();
                      widget.formData.symptoms.addAll(symptoms);

                      // 디버깅을 위한 출력
                      debugPrint('Selected Symptoms:');
                      widget.formData.symptoms.forEach((symptom, isSelected) {
                        if (isSelected) {
                          debugPrint('- $symptom');
                        }
                      });
                      debugPrint(
                          'Special Notes: ${widget.formData.specialNotes}');

                      widget.onNext();
                    }
                  },
                  child: const Text('다음'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 이전에 선택된 증상이 있다면 불러오기
    if (widget.formData.symptoms.isNotEmpty) {
      symptoms.addAll(widget.formData.symptoms);
    }
  }
}
