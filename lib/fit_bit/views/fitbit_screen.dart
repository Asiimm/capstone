import 'package:capstone2/fit_bit/controller/fitbit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../homeScreen/home_screen.dart';
import '../../loginSignup/widget/button.dart';

class FitbitPage extends StatelessWidget {
  const FitbitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF492A87),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
        ),
        body: GetBuilder<FitbitController>(
          init: FitbitController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Fitbit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Connect your Fitbit account to share your steps, sleep, weight, body composition, food, and heart rate data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Regbutton(
                      text: 'Connect to Fitbit',
                      onTab: () {
                        controller.getFitbitData(context);
                      }, // Call _connectToFitbit directly
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'By connecting your Fitbit account, you consent to the collection, use, and disclosure of your Fitbit data in accordance with the Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 20),
                // Text(
                //   'Fitbit Data: $fitbitData',
                //   style: const TextStyle(fontSize: 14, color: Colors.black87),
                // ),
              ],
            );
          },
        ));
  }
}