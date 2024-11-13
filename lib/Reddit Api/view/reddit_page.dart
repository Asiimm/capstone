import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:capstone2/loginSignup/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/Reddit_Controller.dart';

class RedditPage extends StatelessWidget {
  RedditPage({super.key});
  final redditController = Get.put(RedditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF492A87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: Obx(
            () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Reddit',
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
                  'Connect your Reddit account to view posts and comments',
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
                    text: 'Connect to Reddit',
                    onTab: () async {
                      if (redditController.isLoading.value) return;
                      String val = await redditController.getRedditData();
                      if (val != '') {
                        _showSnackbar(context, 'Reddit connected successfully!', AnimatedSnackBarType.success);
                      }
                    },
                  ),
                ],
              ),
              if (redditController.isLoading.value)
                Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    Visibility(
                      visible: redditController.redditPosts.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reddit Posts',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: redditController.redditPosts.map((element) {
                                return ListTile(
                                  title: Text(
                                    "Post Title: ${element['title']}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                //    Text("Comment Author: ${element['author'] ?? 'N/A'}"),
                                    SizedBox(height: 4.0),
                                    Text(
                                      "Post Content: ${element['selftext'] ?? ''}",
                                      style: TextStyle(fontSize: 12, color: Colors.black87),
                                    ),
                                  ],
                                ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: redditController.redditComments.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reddit Comments',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: redditController.redditComments.map((element) {
                                return ListTile(
                                  title: Text(
                                    "Comment: ${element['body']}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                              //    subtitle: Text("Comment Author: ${element['author'] ?? 'N/A'}"),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'By connecting your Reddit account, you consent to the collection, use, and disclosure of your data in accordance with the Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message, AnimatedSnackBarType type) {
    AnimatedSnackBar.material(
      message,
      type: type,
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 500),
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
    ).show(context);
  }
}
