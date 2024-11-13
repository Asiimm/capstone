import 'package:capstone2/Services/auth.dart';
import 'package:capstone2/loginSignup/screen/email_verification.dart';
import 'package:capstone2/loginSignup/screen/login.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/button.dart';
import '../widget/textField.dart';
import 'package:capstone2/Services/google_auth.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String _errorMessage = '';
  bool isLoading = false;

  // Function to sign up the user
  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields';
        isLoading = false;
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
        isLoading = false;
      });
      return;
    }

    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: 'User',
      context: context,
    );

    if (res == "success") {
      setState(() {
        _errorMessage = '';
        isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => EmailVerification()),
      );
    } else {
      setState(() {
        _errorMessage = res;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                // Background decoration
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.007, -1),
                      end: Alignment(0.007, 1),
                      colors: [Color(0xFF301D52), Color(0xFF140D1F)],
                      stops: [0, 0.981],
                    ),
                  ),
                ),

                // Positioned Ellipses
                Positioned(
                  top: screenHeight * 0.3, // Adjust for screen size
                  left: (screenWidth - 329) / 2,
                  child: SvgPicture.asset(
                    'assets/vectors/ellipse_1_x2.svg',
                    width: 329,
                    height: 325,
                  ),
                ),
                Positioned(
                  right: 30,
                  top: screenHeight * 0.85,
                  child: Transform(
                    transform: Matrix4.identity()..rotateZ(3.1396092455),
                    child: SvgPicture.asset(
                      'assets/vectors/ellipse_3_x2.svg',
                      width: 253.3,
                      height: 196.5,
                    ),
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(19.7, 60.7, 18.7, 26.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(14.3, 0, 14.3, 28.2),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Create an \naccount',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.09, // Adjust for screen size
                            color: const Color(0xFFE3E2E6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFieldInput(
                        textEditingController: emailController,
                        hintText: 'Email',
                        textInputType: TextInputType.emailAddress,
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF2A2A3D),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText1 ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText1 = !_obscureText1;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: _obscureText2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF2A2A3D),
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText2 ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.fromLTRB(7.3, 0, 7.3, 51),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'By clicking the Register button, you agree to the terms and conditions',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 11.9,
                            color: const Color(0x4AFFFFFF),
                          ),
                        ),
                      ),
                      isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : Regbutton(
                        onTab: signUpUser,
                        text: "Register",
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12.9),
                        child: Text(
                          'Sign up with',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.5,
                            color: const Color(0xFF615B6F),
                          ),
                        ),
                      ),
                      _buildSocialMediaRow(context),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build social media icons row
  Widget _buildSocialMediaRow(BuildContext context) {
    return SizedBox(
      width: 265.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Google Sign-In Button
          GestureDetector(
            onTap: () async {
              // Attempt to sign in with Google
              User? user = await _googleSignInProvider.signInWithGoogle(
                  context);

              // Only navigate to HomeScreen if the sign-in is successful
              if (user != null) {
                print("Google Sign-In successful: ${user.displayName}");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else {
                print("Google Sign-In failed or was cancelled.");
                _showSignInFailedMessage(context);
              }
            },
            child: _buildSocialMediaIcon('assets/images/image_4.png'),
          ),

          // Placeholder for second social media button (e.g., Facebook)
          GestureDetector(
            onTap: () {
              // Add action for the second button (e.g., Facebook sign-in)
            },
            child: _buildSocialMediaIcon('assets/images/image_6.png'),
          ),

          // Placeholder for third social media button (e.g., Twitter)
          GestureDetector(
            onTap: () {
              // Add action for the third button (e.g., Twitter sign-in)
            },
            child: _buildSocialMediaIcon('assets/images/image_5.png'),
          ),
        ],
      ),
    );
  }

// Function to show a message if sign-in fails or is cancelled
  void _showSignInFailedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Google Sign-In failed or was cancelled."),
      ),
    );
  }

// Widget to build the social media icon buttons
  Widget _buildSocialMediaIcon(String iconPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.8),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(iconPath),
        ),
      ),
      width: 53.5,
      height: 53.5,
    );
  }
}
