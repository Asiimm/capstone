
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:capstone2/logs/logs.dart';
import 'package:capstone2/permission/permission.dart';
import 'package:capstone2/sync/sync.dart';
import 'package:capstone2/loginSignup/screen/account.dart';
import 'package:capstone2/loginSignup/screen/login.dart';
import 'package:capstone2/loginSignup/screen/forget.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:capstone2/loginSignup/screen/email_verification.dart';
import 'package:capstone2/Services/auth_wrapper.dart';

import 'SpotifyApi/views/Screen.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      routes: {
        'account': (context) => Account(),
        'forget': (context) => ForgetPassword(),
        'home_screen': (context) => const HomeScreen(),
        'login': (context) => const Login(),
        'email_verification': (context) => EmailVerification(),
        'sync': (context) => Sync(),
        'logs': (context) => Logs(),
        'permission': (context) => Permission(),
        'screen': (context) => Spotify(),
      },
    );
  }
}
