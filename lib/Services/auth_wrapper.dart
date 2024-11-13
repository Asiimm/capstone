import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:capstone2/loginSignup/screen/login.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in, show HomeScreen
          return const HomeScreen();
        } else {
          // User is not logged in, show Login screen
          return const Login();
        }
      },
    );
  }
}
