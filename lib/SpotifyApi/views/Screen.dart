import 'package:flutter/material.dart';
import '../../homeScreen/Drawer/Drawerlist.dart';
import '../../homeScreen/Drawer/headerDawer.dart';
import '../../homeScreen/home_screen.dart';


class Spotify extends StatefulWidget {
  const Spotify({super.key});

  @override
  State<Spotify> createState() => _SpotifyState();
}

class _SpotifyState extends State<Spotify> {
  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.of(context).size.height; // Get screen height for layout

    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyHeaderDrawer(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                    screenHeight, // Ensures the screen covers the entire height
                  ),
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/background/img.png'), // Replace with your background asset
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //    Positioned( bottom: 100,

              //  child:  ElevatedButton(
              //   onPressed   : () async {
              //        try {
              //          await DynamicLink.instance.createDynamicLink();
              //        } catch (e) {
              // Handle any error
              //          print("Error creating dynamic link: $e");
              //        }
              //      },
              //     child:Text( 'Create Dynamic Link'),
              //     ),// Menu button on the top-right
              //     ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.black, size: 30),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}