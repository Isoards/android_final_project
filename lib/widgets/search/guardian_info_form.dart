import 'package:flutter/material.dart';
import 'package:android_final_project/models/patient_care_model.dart';

class GuardianInfoForm extends StatefulWidget {
  final PatientCareData formData;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const GuardianInfoForm({
    super.key,
    required this.formData,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  State<GuardianInfoForm> createState() => _GuardianInfoFormState();
}

class _GuardianInfoFormState extends State<GuardianInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _phoneControllers = [
    TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
    // 기존 전화번호가 있으면 컨트롤러에 설정
    if (widget.formData.guardianPhones.isNotEmpty) {
      _phoneControllers.clear();
      for (var phone in widget.formData.guardianPhones) {
        _phoneControllers.add(TextEditingController(text: phone));
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _phoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPhoneField() {
    if (_phoneControllers.length < 4) {
      setState(() {
        _phoneControllers.add(TextEditingController());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '보호자 정보 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 보호자 이름
          TextFormField(
            decoration: const InputDecoration(
              labelText: '보호자 이름 *',
              hintText: '홍길동',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '보호자 이름을 입력해주세요';
              }
              return null;
            },
            onChanged: (value) => widget.formData.guardianName = value,
          ),
          const SizedBox(height: 16),

          // 환자와의 관계
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: '환자와의 관계',
              border: OutlineInputBorder(),
            ),
            value: widget.formData.relationship,
            items: const [
              DropdownMenuItem(value: '', child: Text('관계를 선택해주세요')),
              DropdownMenuItem(value: 'child', child: Text('자녀')),
              DropdownMenuItem(value: 'parents', child: Text('부모')),
              DropdownMenuItem(value: 'grandparents', child: Text('조부모')),
              DropdownMenuItem(value: 'sibling', child: Text('형제 * 자매')),
              DropdownMenuItem(value: 'grandchild', child: Text('손자')),
              DropdownMenuItem(value: 'other', child: Text('기타')),
            ],
            onChanged: (String? value) {
              setState(() {
                widget.formData.relationship = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // 보호자 연락처
          ...List.generate(_phoneControllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: _phoneControllers[index],
                decoration: InputDecoration(
                  labelText: '보호자 연락처 ${index + 1}',
                  hintText: '010-1234-5678',
                  border: const OutlineInputBorder(),
                  suffixIcon: index == 0
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              _phoneControllers.removeAt(index);
                            });
                          },
                        ),
                ),
                keyboardType: TextInputType.phone,
              ),
            );
          }),

          if (_phoneControllers.length < 4)
            TextButton.icon(
              onPressed: _addPhoneField,
              icon: const Icon(Icons.add),
              label: const Text('연락처 추가하기'),
            ),

          const SizedBox(height: 16),

          // 보호자 주소
          TextFormField(
            decoration: const InputDecoration(
              labelText: '보호자 주소',
              hintText: '주소를 입력해주세요',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => widget.formData.guardianAddress = value,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '상세주소',
              hintText: '상세주소를 입력해주세요',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => widget.formData.guardianAddressDetail = value,
          ),

          const SizedBox(height: 24),

          // 이전/제출 버튼
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
                      // 전화번호 저장
                      widget.formData.guardianPhones = _phoneControllers
                          .map((controller) => controller.text)
                          .where((phone) => phone.isNotEmpty)
                          .toList();

                      widget.onSubmit();
                      debugPrint(widget.formData.toString());
                    }
                  },
                  child: const Text('찾기'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
