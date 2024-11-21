import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:android_final_project/models/user_model.dart';

class AuthService {
  final _client = Supabase.instance.client;

  // 회원가입
  Future<String?> signUp({
    required String email,
    required String password,
    required String userType,
    required String name,
    required String phone,
    required String gender,
    required DateTime birthDate,
  }) async {
    try {
      // Supabase Auth 회원가입
      final authResponse = await _client.auth.signUp(
          email: email,
          password: password,
          emailRedirectTo: null,
          data: {
            'confirmed_at': DateTime.now().toIso8601String(),
          });

      if (authResponse.user != null) {
        // users 테이블에 추가 정보 저장
        await _client.from('users').insert({
          'id': authResponse.user!.id,
          'email': email,
          'name': name,
          'phone': phone,
          'gender': gender,
          'birth_date': birthDate.toIso8601String(),
          'user_type': userType,
          'created_at': DateTime.now().toIso8601String(),
        });

        return null; // 성공 시 null 반환
      }
      return '회원가입에 실패했습니다.';
    } catch (e) {
      return e.toString(); // 에러 메시지 반환
    }
  }

  // 로그인
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Supabase Auth 로그인
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // 인증 성공시 users 테이블에서 추가 정보 가져오기
        final userData =
            await _client.from('users').select().eq('email', email).single();

        return UserModel(
          id: userData['id'],
          email: userData['email'],
          userType: userData['user_type'],
          name: userData['name'],
          phone: userData['phone'],
          gender: userData['gender'],
          birthDate: DateTime.parse(userData['birth_date']),
        );
      }
      return null;
    } catch (e) {
      throw Exception('로그인 실패: $e');
    }
  }

  // 현재 로그인된 사용자 정보 가져오기
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user != null) {
      try {
        final userData =
            await _client.from('users').select().eq('id', user.id).single();

        return UserModel(
          id: user.id,
          email: user.email!,
          name: userData['name'],
          phone: userData['phone'],
          gender: userData['gender'],
          birthDate: DateTime.parse(userData['birth_date']),
          userType: userData['user_type'],
        );
      } catch (e) {
        throw Exception('사용자 정보 로드 실패: $e');
      }
    }
    return null;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
