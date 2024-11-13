import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth_health_flutter/fitbit_auth_flutter.dart';



class FitbitController extends GetxController {
  void getFitbitData(BuildContext context) async {
    FitbitCredentials fitbitCredentials = await FitBitAuthService.authorize(
        clientID: '23PQQR',
        clientSecret: '12c8b8f0b19ebd96413283caeacfc333',
        redirectUri: 'stressprofiling://callback',
        callbackUrlScheme: 'stressprofiling');
    if (fitbitCredentials.userID.isNotEmpty) {
      log(fitbitCredentials.userID.isNotEmpty.toString());
      AnimatedSnackBar.material(
        'Fitbit connected successfully!!',
        type: AnimatedSnackBarType.success,
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 500),
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      ).show(context);
      update();
    }
  }
}