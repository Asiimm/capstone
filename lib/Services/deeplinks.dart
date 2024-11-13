import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';

class DynamicLink {
  static final DynamicLink _singleton = DynamicLink._internal();
  DynamicLink._internal();
  static DynamicLink get instance => _singleton;

  Future<void> createDynamicLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://CapstoneRedirect.page.link"), // Update this path as needed
      uriPrefix: "https://CapstoneRedirect.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.example.capstone2", // Ensure this matches your app's package name
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.example.capstone2", // Ensure this matches your iOS app's bundle ID
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Your App Title',
        description: 'Description of the link content.',
        imageUrl: Uri.parse('https://your-image-url.com/image.png'), // Add an image URL if desired
      ),
    );

    try {
      final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      Uri shortUrl = shortDynamicLink.shortUrl;
      debugPrint("Short URL: $shortUrl");
    } catch (e) {
      debugPrint("Error creating dynamic link: $e");
    }
  }
}
