import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:android_final_project/database/supabase_config.dart';
import 'pages/auth//user_login_page.dart';

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

  // This widget is the root of your application.
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
        //'/home': (context) => const HomePage(), // 일반 사용자용
        //'/caregiver-home': (context) => const CaregiverHomePage(), // 간병인용
        //'/register': (context) => const RegisterPage(),
      },
    );
  }
}
