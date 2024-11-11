import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:android_final_project/database/models/user_model.dart';

class AuthService {
  final _client = Supabase.instance.client;
  // 로그인
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return UserModel(
          id: response.user!.id,
          email: response.user!.email!,
          // 필요한 경우 추가 정보 조회
        );
      }
      return null;
    } catch (e) {
      throw Exception('로그인 실패: $e');
    }
  }

  // 현재 로그인된 사용자 정보 가져오기
  UserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.id,
        email: user.email!,
      );
    }
    return null;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
