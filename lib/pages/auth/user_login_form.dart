import 'package:flutter/material.dart';

class UserLoginForm extends StatefulWidget {
  const UserLoginForm({super.key});

  @override
  _UserLoginFormState createState() => _UserLoginFormState();
}

class _UserLoginFormState extends State<UserLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleSubmit() {
    // 로그인 처리 로직을 여기에 구현
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
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
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: '패스워드',
              hintText: '비밀번호를 입력해주세요',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('로그인하기'),
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
