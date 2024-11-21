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

        if (!mounted) return;

        if (user != null) {
          if (user.userType == 'caregiver') {
            debugPrint("간병인 로그인 성공");
            Navigator.of(context).pushReplacementNamed('/caregiver-home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('간병인 계정으로만 로그인이 가능합니다.')),
            );
            // 로그아웃 처리
            await _authService.signOut();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인에 실패했습니다.')),
          );
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
      key: _formKey, // Form 키 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '아이디',
              hintText: '이메일/아이디를 입력해주세요',
              prefixIcon: Icon(Icons.email), // 아이콘 추가
            ),
            keyboardType: TextInputType.emailAddress, // 이메일 키보드 타입
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력하세요';
              }
              if (!value.contains('@')) {
                return '올바른 이메일 형식이 아닙니다';
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
              prefixIcon: Icon(Icons.lock), // 아이콘 추가
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력하세요';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    '로그인하기',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
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
