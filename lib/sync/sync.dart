import 'package:capstone2/loginSignup/widget/button.dart'; // Import your button widget if needed
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sync extends StatelessWidget {
  const Sync({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/sync.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.07, top: screenHeight * 0.1),
                        child: Text(
                          'Sync Data',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.1, // Responsive font size
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(screenWidth * 0.02, 0, screenWidth * 0.02, screenHeight * 0.07),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.07),
                        child: Text(
                          'Connect your digital health data to understand\nthe effects of your health parameters on stress',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.035, // Responsive font size
                            color: const Color(0xFFD3CDE6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Search Field
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2A2A3D),
                        hintText: 'Search app',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),

                    const Spacer(), // Automatically fills up space, moving back button to the bottom

                    // Back button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Add some space at the bottom
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.05, // Responsive position for Skip button
              right: screenWidth * 0.05,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "logs"); // Change to your next screen route
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.035, // Responsive font size
                    color: const Color(0xFF422477),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}