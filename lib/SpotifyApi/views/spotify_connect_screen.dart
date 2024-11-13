//connect.dart

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:capstone2/spotifyapi/controller/spotify_controller.dart';
import 'package:capstone2/loginSignup/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpotifyPage extends StatelessWidget {
  SpotifyPage({super.key});
  final spotifyController = Get.put(SpotifyController());

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
                'Spotify',
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
                  'Connect your Spotify account to share your music playlist',
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
                    text: 'Connect to Spotify',
                    onTab: () async {
                      if (spotifyController.isLoadingPlaylist.value) return;
                      String val = await spotifyController.getSpotifyData();
                      if (val != '') {
                        _showSnackbar(context, 'Spotify connected successfully!', AnimatedSnackBarType.success);
                      }
                    },
                  ),
                ],
              ),
              if (spotifyController.isLoadingPlaylist.value)
                Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    Visibility(
                      visible: spotifyController.userPlaylist.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Playlist',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: spotifyController.userPlaylist.map((element) {
                                return ListTile(
                                  title: Text(
                                    "Playlist ID: ${element.playlistId}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text("Playlist Name: ${element.playlistName}"),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: spotifyController.recentPlayed.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recently Played',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: spotifyController.recentPlayed.map((element) {
                                return ListTile(
                                  title: Text(
                                    "Track Name: ${element.trackName}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    "Artist Name: ${element.artistNames.map((artist) => artist.name).join(', ')}",
                                  ),
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
                  'By connecting your Spotify account, you consent to the collection, use, and disclosure of your data in accordance with the Privacy Policy.',
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
