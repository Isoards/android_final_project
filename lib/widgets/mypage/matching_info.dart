import 'package:flutter/material.dart';
import 'package:android_final_project/models/patient_care_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CareMatchingCard extends StatefulWidget {
  final PatientCareData careData;

  const CareMatchingCard({
    super.key,
    required this.careData,
  });

  @override
  State<CareMatchingCard> createState() => _CareMatchingCardState();
}

class _CareMatchingCardState extends State<CareMatchingCard> {
  Map<String, dynamic>? requestData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCareRequestData();
  }

  Future<void> fetchCareRequestData() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final response = await supabase
          .from('care_requests')
          .select('''
            *,
            patients!inner(
              guardian_id,
              patient_name,
              patient_birth_date,
              patient_height,
              patient_weight,
              patient_gender
            ),
            symptoms(
              symptom_name,
              is_present
            )
          ''')
          .eq('patients.guardian_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      if (mounted) {
        setState(() {
          requestData = response;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching request data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String getStatusText(String? status) {
    switch (status) {
      case 'accepted':
        return '수락됨';
      case 'rejected':
        return '거절됨';
      case 'requested':
        return '수락 대기 중';
      default:
        return '수락 대기 중';
    }
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'requested':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '간병 매칭 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isLoading && requestData != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(requestData?['status'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: getStatusColor(requestData?['status'])),
                    ),
                    child: Text(
                      getStatusText(requestData?['status']),
                      style: TextStyle(
                        color: getStatusColor(requestData?['status']),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 환자 정보
                        _buildSection('환자 정보', [
                          '이름: ${widget.careData.patientName}',
                          '생년월일: ${widget.careData.patientBirthDate}',
                          '성별: ${widget.careData.patientGender}',
                          '키: ${widget.careData.patientHeight}cm',
                          '몸무게: ${widget.careData.patientWeight}kg',
                        ]),
                        const SizedBox(height: 16),
                        // 질병 및 증상 정보
                        _buildSection('질병 및 증상', [
                          '질병명: ${widget.careData.diseaseName}',
                          ...widget.careData.symptoms?.entries.map((e) =>
                                  '${e.key}: ${e.value ? "있음" : "없음"}') ??
                              [],
                        ]),
                        const SizedBox(height: 16),
                        // 간병 정보
                        _buildSection('간병 정보', [
                          '기간: ${widget.careData.startDate?.toString().split(' ')[0]} ~ ${widget.careData.endDate?.toString().split(' ')[0]}',
                          '시간: ${widget.careData.dailyStartTime?.substring(0, 5) ?? ''} ~ ${widget.careData.dailyEndTime?.substring(0, 5) ?? ''}',
                          '주말 포함: ${widget.careData.includeWeekends ? "예" : "아니오"}',
                          '장소: ${widget.careData.reservationLocation}',
                          if (widget.careData.locationDetail != null)
                            '상세 위치: ${widget.careData.locationDetail}',
                          if (widget.careData.specialNotes != null)
                            '특이사항: ${widget.careData.specialNotes}',
                        ]),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(item),
            )),
      ],
    );
  }
}
