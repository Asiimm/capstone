import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capstone2/loginSignup/widget/textField.dart';
import 'package:capstone2/loginSignup/widget/button.dart';
import 'package:capstone2/Services/auth.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:capstone2/loginSignup/widget/snackbar.dart';
import 'package:capstone2/Services/google_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  bool _isPasswordVisible = true; // Track the password visibility
  bool isLoading = false;
  String _errorMessage = '';

  // Function to handle login
  void _loginUser() async {
    setState(() {
      isLoading = true;
    });

    // Check if email or password is empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
        isLoading = false;
      });
      showSnackBar(context, _errorMessage);
      return;
    }

    // Call the login method
    String res = await AuthMethod().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      // Navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = res;
        isLoading = false;
      });
      // Show error message
      showSnackBar(context, _errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:false,
      body: Stack(
        children: [
          // Background image that covers the entire screen
          Container(
            height: screenHeight, // Full height for the background
            width: screenWidth, // Full width for the background
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Scrollable content on top of the static background
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    screenHeight * 0.08,
                    screenWidth * 0.05,
                    screenHeight * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.1, top: screenHeight * 0.05),
                          child: Text(
                            'Welcome\nBack!',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.1, // Responsive font size
                              color: const Color(0xFFD3CDE6),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.07), // Responsive space

                      // Email input field
                      TextFieldInput(
                        textEditingController: emailController,
                        hintText: 'Email',
                        textInputType: TextInputType.emailAddress,
                        icon: Icons.email,
                      ),

                      SizedBox(height: screenHeight * 0.02), // Responsive space

                      // Password input field with visibility toggle
                      TextField(
                        controller: passwordController,
                        obscureText: _isPasswordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF2A2A3D),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
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

                      // Error message if any
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      SizedBox(height: screenHeight * 0.02),

                      // Create an account and Forgot password buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'account');
                            },
                            child: Text(
                              'Create an account',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.03, // Responsive font size
                                color: Colors.white54,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'forget');
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.03, // Responsive font size
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Login Button
                      isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : Regbutton(
                        onTab: _loginUser,
                        text: "Login",
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Social Media Signup text
                      Text(
                        'Sign up with',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * 0.03,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      // Social Media Icons
                      _buildSocialMediaRow(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
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
              User? user = await _googleSignInProvider.signInWithGoogle(context);

              // Only navigate to HomeScreen if the sign-in is successful
              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
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
