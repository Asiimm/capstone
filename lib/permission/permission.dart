import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Permission extends StatelessWidget {
  const Permission({super.key});

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
            image: AssetImage("assets/background/forget.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05), // Dynamic padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.07, top: screenHeight * 0.1),
                        child: Text(
                          'Enable \nPermission',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.1, // Responsive font size
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.25), // Dynamic spacing

                    // Permission Description Text
                    Container(
                      margin: EdgeInsets.only(left: screenWidth * 0.03),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Text(
                          'Some features of the app\nrequire data access permission.\nYour data will only be shared\nwith people you give permission to.\nWe respect your privacy.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.035, // Responsive font size
                            color: const Color(0xFFD3CDE6),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(), // Pushes the back button to the bottom

                    // Back Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white,),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adds spacing at the bottom
                  ],
                ),
              ),
            ),

            // Skip Button Positioned
            Positioned(
              top: screenHeight * 0.05,
              right: screenWidth * 0.05,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "home_screen"); // Change this to your next screen route
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.035, // Responsive font size
                    color: Colors.white,
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
