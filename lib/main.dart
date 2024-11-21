import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:android_final_project/database/supabase_config.dart';
import 'pages/auth/login_page.dart';
import 'package:android_final_project/pages/home/caregiver_home_page.dart';
import 'package:android_final_project/pages/home/patient_home_page.dart';
import 'package:android_final_project/pages/search/caregiver_search_page.dart';
import 'package:android_final_project/pages/auth/signup_page.dart';
import 'package:android_final_project/pages/auth/signup_success_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    debugPrint("Database Success");
  } catch (error) {
    debugPrint("error : $error");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '간병인 매칭 플랫폼',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const UserLoginPage(),
        '/patient-home': (context) => const PatientHomePage(), // 일반 사용자용
        '/caregiver-home': (context) => const CaregiverHomePage(), // 간병인용
        '/search': (context) => const CaregiverSearch(), // 간병인 찾기
        '/signup': (context) => const SignupPage(),
        '/signup-success': (context) => const SignupSuccessPage(),
      },
    );
  }
}
