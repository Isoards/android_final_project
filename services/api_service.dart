import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio();
  
  static Future<Response> userLogin(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/user/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> caregiverLogInAPI(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/caregiver/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}