import 'package:capstone2/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capstone2/loginSignup/widget/button.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword> {
  // Controllers
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Password Reset Function
  Future<void> passwordReset() async {
    String email = emailController.text.trim();
    if (email.isNotEmpty) {
      String result = await AuthMethod().resetPassword(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          duration: Duration(seconds: 2),
        ),
      );
      if (result.startsWith("Password reset")) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email address."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents content from moving up when keyboard appears
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/forget.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.08, top: screenHeight * 0.06),
                        child: Text(
                          'Forget\nPassword?',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.11, // Adjusted for screen size
                            color: Color(0xFFD3CDE6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08), // Adaptive spacing
                    TextField(
                      controller: emailController, // Assign the controller
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2A2A3D),
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.email, color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.fromLTRB(7.3, 0, 7.3, 51),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'We will send you a message to set or reset your password',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.9,
                          color: const Color(0x4AFFFFFF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.fromLTRB(18.2, 0, 0, 49.1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.8),
                        gradient: const LinearGradient(
                          begin: Alignment(-1, -0.022),
                          end: Alignment(1, 0.022),
                          colors: [Color(0xFF4A3DE0), Color(0xFF6B21A6)],
                          stops: [0, 1],
                        ),
                      ),
                    ),
                    Regbutton(
                      onTab: passwordReset, // Call the passwordReset function
                      text: "Reset Password",
                    ),
                    Spacer(), // Pushes content above as much as needed
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Bottom spacing
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
