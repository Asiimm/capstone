import 'package:capstone2/Reddit%20Api/view/reddit_page.dart';
import 'package:flutter/material.dart';
import '../../Services/auth.dart';
import '../../SpotifyApi/views/Screen.dart';
import '../../SpotifyApi/views/spotify_connect_screen.dart';
import '../../camera/camera.dart';
import '../../fit_bit/views/fitbit_screen.dart';
import '../../loginSignup/screen/login.dart';
import '../Profile.dart';

class MyDrawerList extends StatefulWidget {
  const MyDrawerList({super.key});

  @override
  State<MyDrawerList> createState() => _MyDrawerListState();
}

class _MyDrawerListState extends State<MyDrawerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account'),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>  Profile(),),
              );// Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.watch),
            title: const Text('Fitbit'),
            onTap: () async => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => FitbitPage(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.library_music),
            title: const Text('Spotify'),
            onTap: () async => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SpotifyPage(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.reddit),
            title: const Text('reddit'),
            onTap: () async => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => RedditPage(),
              ),
            ),
          ),
          ListTile(
           leading: Icon(Icons.photo),
           title: const Text('Camer'),
            onTap: () async => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CameraPage(),
             ),
            ),
           ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await AuthMethod().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
