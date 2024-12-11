import 'package:flutter/material.dart';
import 'package:android_final_project/services/auth_service.dart';
import 'package:android_final_project/models/user_model.dart';
import 'package:android_final_project/models/patient_care_model.dart';
import 'package:android_final_project/widgets/mypage/matching_info.dart';
import 'package:android_final_project/services/care_matching_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:android_final_project/widgets/mypage/care_request.dart';
import 'package:android_final_project/widgets/mypage/review.dart';
import 'package:android_final_project/models/review_model.dart';
import 'package:android_final_project/services/review_service.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final AuthService _authService = AuthService();
  UserModel? userData;
  PatientCareData? careData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      final matchingService = CareMatchingService(Supabase.instance.client);
      final matchingInfo = await matchingService.getCareMatchingInfo(user!.id);

      setState(() {
        userData = user;
        careData = matchingInfo;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '안녕하세요, ${userData?.name ?? ''}님',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 프로필 & 결제 정보 섹션
              Row(
                children: [
                  // 프로필 정보
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      userData?.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.edit, size: 20),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _authService.signOut();
                                    if (mounted) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/');
                                    }
                                  },
                                  child: const Text('로그아웃'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '이메일: ${userData?.email ?? ''}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '전화번호: ${userData?.phone ?? ''}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '성별: ${userData?.gender ?? ''}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '생년월일: ${userData?.birthDate.toString().split(' ')[0] ?? ''}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '사용자 유형: ${userData?.userType == 'patient' ? '환자/보호자' : '간병인'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (careData != null)
                CareMatchingCard(careData: careData!)
              else if (userData?.userType == 'caregiver')
                const CareRequestsCard()
              else
                const Center(child: Text('매칭 정보가 없습니다.')),
              const SizedBox(height: 20),
              _buildReviewsSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
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
                  '리뷰',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ReviewDialog(
                        targetId: userData!.id,
                        onReviewSubmitted: () {
                          setState(() {
                            // Refresh reviews
                          });
                        },
                      ),
                    );
                  },
                  child: const Text('리뷰 작성'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<ReviewModel>>(
              future: ReviewService(Supabase.instance.client)
                  .getReviewsForUser(userData!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('아직 리뷰가 없습니다.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final review = snapshot.data![index];
                    return ListTile(
                      title: Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            review.createdAt.toString().split(' ')[0],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Text(review.content),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
