import 'dart:async'; // Import this to use Timer
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isResent = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck();
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      User? user = _auth.currentUser;
      await user?.reload(); // Reload user to update the email verification status
      user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        _timer?.cancel(); // Stop the timer
        Navigator.of(context).pushReplacementNamed('sync');
      }
    });
  }

  Future<void> _sendVerificationEmail() async {
    final user = _auth.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        setState(() {
          _isResent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email resent! Please check your inbox.'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend email: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Stack(
        children: [
          // Background gradient with circles
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E153A), // Dark purple
                  Color(0xFF2A1D46),
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFE91E63), // Pink
                    Color(0xFFD81B60),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: 50,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFE91E63), // Pink
                    Color(0xFFD81B60),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF673AB7), // Blue
                    Color(0xFF512DA8),
                  ],
                ),
              ),
            ),
          ),
          // Email verification UI
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A verification email has been sent to ${user?.email}. Please check your inbox and follow the instructions to verify your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendVerificationEmail,
                  child: Text('Resend Email'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context).pushReplacementNamed('login');
                  },
                  child: Text('Log Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
