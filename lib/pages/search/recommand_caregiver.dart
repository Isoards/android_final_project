import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecommendedCaregiverList extends StatefulWidget {
  const RecommendedCaregiverList({super.key});

  @override
  State<RecommendedCaregiverList> createState() =>
      _RecommendedCaregiverListState();
}

class _RecommendedCaregiverListState extends State<RecommendedCaregiverList> {
  List<Map<String, dynamic>> caregivers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCaregivers();
  }

  Future<void> fetchCaregivers() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.from('caregiver_profiles').select('''
          *,
          work_histories(*)
        ''');

      setState(() {
        caregivers = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching caregivers: $e');
      setState(() => isLoading = false);
    }
  }

  Widget buildCaregiverCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '국적: ${data['nationality'] ?? '정보 없음'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('자격증: ${data['certification'] ?? '없음'}'),
                  Text('자기소개: ${data['career_description'] ?? '없음'}'),
                  if ((data['work_histories'] as List?)?.isNotEmpty ?? false)
                    Text(
                      '경력: ${data['work_histories'][0]['work_place']} (${data['work_histories'][0]['start_date']} ~ ${data['work_histories'][0]['end_date']})',
                      style: const TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/patient-home', (route) => false,
                    arguments: data);
                const SnackBar(content: Text('간병인 요청이 성공적으로 등록되었습니다.'));
              },
              child: const Text('간병 요청하기'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 간병인 리스트'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '환자 정보를 기반으로 맞춤케어가 가능한 추천 간병인 리스트입니다.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...caregivers.map((data) => buildCaregiverCard(data)),
        ],
      ),
    );
  }
}
