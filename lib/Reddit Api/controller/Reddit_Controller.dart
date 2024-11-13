import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RedditController extends GetxController {
  RxList<dynamic> redditPosts = <dynamic>[].obs;
  RxList<dynamic> redditComments = <dynamic>[].obs;
  RxBool isLoading = false.obs;
  Timer? _timer;
  String? _accessToken;
  String? _refreshToken;
  String? _username;

  @override
  void onInit() {
    super.onInit();
    _initializeReddit();
  }

  Future<void> _initializeReddit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('redditAccessToken');
    _refreshToken = prefs.getString('redditRefreshToken');

    if (_accessToken != null) {
      await fetchRedditUsername();
      startPeriodicFetch();
    } else {
      await getRedditData();
    }
  }

  Future<void> fetchRedditUsername() async {
    final response = await http.get(
      Uri.parse('https://oauth.reddit.com/api/v1/me'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'User-Agent': 'YourAppName/0.1 by YourRedditUsername',
      },
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      _username = userData['name'];
      log('Fetched Reddit username: $_username');
    } else {
      debugPrint('Failed to fetch username: ${response.body}');
    }
  }

  Future<String> getRedditData() async {
    try {
      var redirectUri = Uri.https('www.reddit.com', '/api/v1/authorize', {
        'client_id': 'tyfTAeYo4kIZQW7p9pcd9Q',
        'response_type': 'code',
        'redirect_uri': 'stressprofiling://callback',
        'scope': 'identity read history',
        'state': 'random_string',
        'duration': 'permanent',
      });

      final result = await FlutterWebAuth.authenticate(
        url: redirectUri.toString(),
        callbackUrlScheme: 'stressprofiling',
      );

      String? token = await exchangeCodeForToken(extractCodeFromUrl(result) ?? '');
      if (token.isNotEmpty) {
        _accessToken = token;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('redditAccessToken', _accessToken!);
        await fetchRedditUsername();
        startPeriodicFetch();
      }
      return token;
    } catch (e) {
      debugPrint('Error during Reddit authorization: $e');
      isLoading.value = false;
      return '';
    }
  }

  String? extractCodeFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.queryParameters['code'];
  }

  Future<String> exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse('https://www.reddit.com/api/v1/access_token'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('tyfTAeYo4kIZQW7p9pcd9Q:3JHuH0U1dS5ll_DhDfwyDt60RDAuRQ')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': 'stressprofiling://callback',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _accessToken = jsonResponse['access_token'];
      _refreshToken = jsonResponse['refresh_token'];
      _scheduleTokenRefresh(jsonResponse['expires_in']);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('redditAccessToken', _accessToken!);
      await prefs.setString('redditRefreshToken', _refreshToken!);

      log('Access token: $_accessToken');
      log('Refresh token: $_refreshToken');

      return _accessToken!;
    }
    debugPrint('Failed to get token: ${response.body}');
    return '';
  }

  void _scheduleTokenRefresh(int expiresIn) {
    Future.delayed(Duration(seconds: expiresIn - 60), () async {
      if (_refreshToken != null) {
        await refreshAccessToken();
      }
    });
  }

  Future<void> refreshAccessToken() async {
    final response = await http.post(
      Uri.parse('https://www.reddit.com/api/v1/access_token'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('tyfTAeYo4kIZQW7p9pcd9Q:3JHuH0U1dS5ll_DhDfwyDt60RDAuRQ')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': _refreshToken!,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _accessToken = jsonResponse['access_token'];
      _scheduleTokenRefresh(jsonResponse['expires_in']);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('redditAccessToken', _accessToken!);

      log('Refreshed access token: $_accessToken');
    } else {
      debugPrint('Failed to refresh token: ${response.body}');
    }
  }

  void startPeriodicFetch() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (_accessToken != null && _username != null) {
        fetchRedditPosts();
        fetchRedditComments();
      }
    });
  }

  Future<void> fetchRedditPosts() async {
    isLoading.value = true;

    final response = await http.get(
      Uri.parse('https://oauth.reddit.com/user/$_username/submitted'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      redditPosts.clear();
      final postsData = json.decode(response.body);
      for (var post in postsData['data']['children']) {
        final postData = post['data'];
        redditPosts.add({
          'title': postData['title'],
          'selftext': postData['selftext'],  // Fetch the body content for text posts
        });
      }
    } else {
      debugPrint('Failed to fetch user posts: ${response.body}');
    }

    isLoading.value = false;
  }


  Future<void> fetchRedditComments() async {
    final response = await http.get(
      Uri.parse('https://oauth.reddit.com/user/$_username/comments'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'User-Agent': 'YourAppName/0.1 by YourRedditUsername',
      },
    );

    if (response.statusCode == 200) {
      redditComments.clear();
      final commentsData = json.decode(response.body);
      for (var comment in commentsData['data']['children']) {
        redditComments.add(comment['data']);
      }
    } else {
      debugPrint('Failed to fetch user comments: ${response.body}');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
