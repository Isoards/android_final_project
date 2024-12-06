import 'package:flutter/material.dart';
import 'package:android_final_project/models/caregiver_profile_model.dart';

class WorkExperienceForm extends StatefulWidget {
  final CaregiverProfileData formData;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const WorkExperienceForm({
    super.key,
    required this.formData,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  State<WorkExperienceForm> createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<WorkExperienceForm> {
  final List<String> certifications = [
    '요양보호사 자격증',
    '간호조무사 자격증',
    '사회복지사 자격증',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '어떤 일을 했었는지 알려주세요.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: widget.formData.certification,
          decoration: const InputDecoration(
            labelText: '면허/자격증 종류 선택 및 인증',
            border: OutlineInputBorder(),
          ),
          items: certifications.map((cert) {
            return DropdownMenuItem(
              value: cert,
              child: Text(cert),
            );
          }).toList(),
          onChanged: (value) => widget.formData.certification = value,
        ),
        const SizedBox(height: 16),
        const Text('근무 경력 기재 및 인증'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.formData.workHistories.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.formData.workHistories.length) {
              if (index < 3) {
                return TextButton(
                  onPressed: () {
                    setState(() {
                      widget.formData.workHistories.add(
                        WorkHistory(
                          workPlace: '',
                          startDate: '',
                          endDate: '',
                        ),
                      );
                    });
                  },
                  child: const Text('+ 경력 추가'),
                );
              }
              return const SizedBox.shrink();
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue:
                          widget.formData.workHistories[index].workPlace,
                      decoration: const InputDecoration(
                        labelText: '근무처',
                        hintText: '00병원 00동 2년 근무',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.formData.workHistories[index] = WorkHistory(
                            workPlace: value,
                            startDate:
                                widget.formData.workHistories[index].startDate,
                            endDate:
                                widget.formData.workHistories[index].endDate,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                widget.formData.workHistories[index].startDate,
                            decoration: const InputDecoration(
                              labelText: '시작일',
                              hintText: 'YYYY-MM-DD',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                widget.formData.workHistories[index] =
                                    WorkHistory(
                                  workPlace: widget
                                      .formData.workHistories[index].workPlace,
                                  startDate: value,
                                  endDate: widget
                                      .formData.workHistories[index].endDate,
                                );
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('~'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                widget.formData.workHistories[index].endDate,
                            decoration: const InputDecoration(
                              labelText: '종료일',
                              hintText: 'YYYY-MM-DD',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                widget.formData.workHistories[index] =
                                    WorkHistory(
                                  workPlace: widget
                                      .formData.workHistories[index].workPlace,
                                  startDate: widget
                                      .formData.workHistories[index].startDate,
                                  endDate: value,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.formData.careerDescription,
          decoration: const InputDecoration(
            labelText: '자기소개',
            hintText: '근무 경력과 관련지어 소개글을 작성하면, 더 많은 도움을 줄 수 있는 환자와 매칭이 가능해집니다.',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) => widget.formData.careerDescription = value,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onPrevious,
              child: const Text('이전'),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.formData.isWorkExperienceValid()) {
                  widget.onSubmit();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 필수 항목을 입력해주세요.')),
                  );
                }
              },
              child: const Text('가입'),
            ),
          ],
        ),
      ],
    );
  }
}
