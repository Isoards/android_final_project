import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CareRequestsCard extends StatefulWidget {
  const CareRequestsCard({super.key});

  @override
  State<CareRequestsCard> createState() => _CareRequestsCardState();
}

class _CareRequestsCardState extends State<CareRequestsCard> {
  List<Map<String, dynamic>> careRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCareRequests();
  }

  Future<void> fetchCareRequests() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.from('care_requests').select('''
          *,
          patients(*)
        ''').order('created_at'); // status 필터 제거

      debugPrint('Response: $response'); // 데이터 확인용

      setState(() {
        careRequests = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching care requests: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> handleResponse(String requestId, String status) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('care_requests').update({
        'status': status,
      }).eq('id', requestId);

      // 목록 새로고침
      fetchCareRequests();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(status == 'accepted' ? '간병 요청을 수락했습니다' : '간병 요청을 거절했습니다'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('처리 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '간병 요청 목록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (careRequests.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('새로운 간병 요청이 없습니다'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: careRequests.length,
                itemBuilder: (context, index) {
                  final request = careRequests[index];
                  final patient = request['patients'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '환자: ${patient['patient_name']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            buildStatusIndicator(
                                request['status'] ?? 'pending'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('질병명: ${request['disease_name']}'),
                        Text('위치: ${request['reservation_location']}'),
                        if (request['location_detail'] != null)
                          Text('상세 위치: ${request['location_detail']}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                                '간병 시간: ${request['daily_start_time']} ~ ${request['daily_end_time']}'),
                          ],
                        ),
                        Text(
                            '주말 포함: ${request['include_weekends'] ? '예' : '아니오'}'),
                        if (request['start_date'] != null)
                          Text('시작일: ${request['start_date']}'),
                        if (request['end_date'] != null)
                          Text('종료일: ${request['end_date']}'),
                        if (request['special_notes'] != null &&
                            request['special_notes'].toString().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                '특이사항:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(request['special_notes']),
                            ],
                          ),
                        const SizedBox(height: 8),
                        if (request['status'] == null ||
                            request['status'] == 'pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    handleResponse(request['id'], 'rejected'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('거절'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    handleResponse(request['id'], 'accepted'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('수락'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

Widget buildStatusIndicator(String status) {
  Color color;
  String text;

  switch (status) {
    case 'accepted':
      color = Colors.green;
      text = '수락됨';
      break;
    case 'rejected':
      color = Colors.red;
      text = '거절됨';
      break;
    default:
      color = Colors.orange;
      text = '대기중';
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: color),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 12),
    ),
  );
}
