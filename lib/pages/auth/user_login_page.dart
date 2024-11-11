import 'package:flutter/material.dart';
import 'user_login_form.dart';
import 'caregiver_login_form.dart';
import 'package:android_final_project/pages/register/register_page.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  String selectedType = "환자/보호자"; // 기본 선택

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // 토글 버튼
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == "환자/보호자"
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                      ),
                      onPressed: () => setState(() => selectedType = "환자/보호자"),
                      child: const Text(
                        '환자/보호자',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == "간병인"
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                      ),
                      onPressed: () => setState(() => selectedType = "간병인"),
                      child: const Text(
                        '간병인',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // 조건부 폼 렌더링
              Expanded(
                child: selectedType == "환자/보호자"
                    ? const UserLoginForm()
                    : const CaregiverLoginForm(),
              ),
              // 회원가입 링크
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '아직 계정이 없으신가요? ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: '회원가입 하기',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
