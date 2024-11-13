import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SpotifyApi/views/Screen.dart';



class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/Spotify':
        return CupertinoPageRoute(builder: (_) {
          return const Spotify();
        });

        }
        return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}