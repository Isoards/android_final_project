import 'package:flutter/material.dart';
import 'package:android_final_project/services/auth_service.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
    'name': '',
    'phone': '',
    'gender': '',
    'birthDate': DateTime.now(),
    'userType': '', // 'patient' or 'caregiver'
  };

  bool _isLoading = false;

  void _handleUserTypeSelect(String type) {
    setState(() {
      _formData['userType'] = type;
    });
  }

  void _handleGenderSelect(String gender) {
    setState(() {
      _formData['gender'] = gender;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _formData['birthDate'],
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _formData['birthDate']) {
      setState(() {
        _formData['birthDate'] = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final error = await _authService.signUp(
          email: _formData['email'],
          password: _formData['password'],
          name: _formData['name'],
          phone: _formData['phone'],
          gender: _formData['gender'],
          birthDate: _formData['birthDate'],
          userType: _formData['userType'],
        );

        setState(() => _isLoading = false);

        if (!mounted) return;

        if (error == null) {
          Navigator.pushReplacementNamed(context, '/signup-success');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 유형 선택
            const Text(
              '가입 유형을 선택해주세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleUserTypeSelect('patient'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _formData['userType'] == 'patient'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    child: const Text('환자/보호자',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleUserTypeSelect('caregiver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _formData['userType'] == 'caregiver'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    child: const Text(
                      '간병인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 이름 입력
            TextFormField(
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '이름을 입력해주세요',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
              onChanged: (value) => _formData['name'] = value,
            ),
            const SizedBox(height: 16),

            // 이메일 입력
            TextFormField(
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: '이메일을 입력해주세요',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이메일을 입력해주세요';
                }
                if (!value.contains('@')) {
                  return '올바른 이메일 형식이 아닙니다';
                }
                return null;
              },
              onChanged: (value) => _formData['email'] = value,
            ),
            const SizedBox(height: 16),

            // 비밀번호 입력
            TextFormField(
              decoration: const InputDecoration(
                labelText: '비밀번호',
                hintText: '비밀번호를 입력해주세요',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                if (value.length < 6) {
                  return '비밀번호는 6자 이상이어야 합니다';
                }
                return null;
              },
              onChanged: (value) => _formData['password'] = value,
            ),
            const SizedBox(height: 16),

            // 전화번호 입력
            TextFormField(
              decoration: const InputDecoration(
                labelText: '휴대폰 번호',
                hintText: '010-1234-5678',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '전화번호를 입력해주세요';
                }
                return null;
              },
              onChanged: (value) => _formData['phone'] = value,
            ),
            const SizedBox(height: 16),

            // 생년월일 선택
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: '생년월일',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: '${_formData['birthDate'].year}-'
                        '${_formData['birthDate'].month.toString().padLeft(2, '0')}-'
                        '${_formData['birthDate'].day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 성별 선택
            const Text(
              '성별',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleGenderSelect('남성'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _formData['gender'] == '남성'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    child:
                        const Text('남성', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleGenderSelect('여성'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _formData['gender'] == '여성'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    child:
                        const Text('여성', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 회원가입 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '회원가입',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
