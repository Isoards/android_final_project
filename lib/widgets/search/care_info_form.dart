import 'package:flutter/material.dart';
import 'package:android_final_project/models/patient_care_model.dart';

class CareInfoForm extends StatefulWidget {
  final PatientCareData formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const CareInfoForm({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<CareInfoForm> createState() => _CareInfoFormState();
}

class _CareInfoFormState extends State<CareInfoForm> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('간병 정보 입력',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '진단명 *',
              hintText: '진단명을 입력해주세요',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '진단명을 입력해주세요';
              }
              return null;
            },
            onSaved: (value) {
              widget.formData.diseaseName = value;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '간병 장소 *',
              hintText: '주소를 입력해주세요',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '간병 장소를 입력해주세요';
              }
              return null;
            },
            onSaved: (value) {
              widget.formData.reservationLocation = value;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '상세주소',
              hintText: '상세주소를 입력해주세요',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => widget.formData.locationDetail = value,
          ),
          const SizedBox(height: 16),
          const Text('간병 기간 *'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: '시작일',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        widget.formData.startDate = date;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: widget.formData.startDate?.toString().split(' ')[0] ??
                        '',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('~'),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: '종료일',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: widget.formData.startDate ?? DateTime.now(),
                      firstDate: widget.formData.startDate ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        widget.formData.endDate = date;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text:
                        widget.formData.endDate?.toString().split(' ')[0] ?? '',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('간병 시간 *'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: '시작 시간',
                    hintText: '시작 시간 선택',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '시작 시간을 선택해주세요';
                    }
                    return null;
                  },
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _startTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _startTime = time;
                        widget.formData.dailyStartTime =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _startTime?.format(context) ?? '',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('~'),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: '종료 시간',
                    hintText: '종료 시간 선택',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '종료 시간을 선택해주세요';
                    }
                    return null;
                  },
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _endTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _endTime = time;
                        widget.formData.dailyEndTime =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _endTime?.format(context) ?? '',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('주말 포함'),
            value: widget.formData.includeWeekends,
            onChanged: (bool? value) {
              setState(() {
                widget.formData.includeWeekends = value ?? false;
              });
            },
          ),
          const SizedBox(height: 24),
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
                      _formKey.currentState!.save(); // onSaved 콜백 호출
                      widget.formData.printCareInfo(); // 간병 정보 확인
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
}
