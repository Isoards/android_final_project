import 'package:flutter/material.dart';
import 'package:android_final_project/services/auth_service.dart';

class CaregiverLoginForm extends StatefulWidget {
  const CaregiverLoginForm({super.key});

  @override
  State<CaregiverLoginForm> createState() => _CaregiverLoginFormState();
}

class _CaregiverLoginFormState extends State<CaregiverLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = await _authService.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (user != null && mounted) {
          debugPrint("로그인 성공");
          // 간병인 전용 홈 페이지로 이동
          Navigator.of(context).pushReplacementNamed('/caregiver-home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '아이디',
              hintText: '이메일/아이디를 입력해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력하세요';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: '패스워드',
              hintText: '비밀번호를 입력해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력하세요';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('로그인하기'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
