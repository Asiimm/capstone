import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:capstone2/models/recent_played.dart';
import 'package:capstone2/models/user_playlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SpotifyController extends GetxController {
  RxList<UserPlaylist> userPlaylist = <UserPlaylist>[].obs;
  RxList<RecentPlayed> recentPlayed = <RecentPlayed>[].obs;
  RxBool isLoadingPlaylist = false.obs;
  Timer? _timer;
  String? _accessToken;

  @override
  void onInit() {
    super.onInit();
    _initializeSpotify();
  }

  Future<void> _initializeSpotify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('spotifyAccessToken');

    if (_accessToken != null) {
      startPeriodicFetch();
    } else {
      await getSpotifyData();
    }
  }

  Future<String> getSpotifyData() async {
    try {
      var redirectUri = Uri.https('accounts.spotify.com', '/authorize', {
        'client_id': 'cf3bc77109b0414899a50d541efdaca5',
        "response_type": "code",
        "redirect_uri": "stressprofiling://callback",
        "scope": 'user-read-private user-read-email user-read-recently-played',
        "show_dialog": "true",
      });

      final result = await FlutterWebAuth.authenticate(
        url: redirectUri.toString(),
        callbackUrlScheme: "stressprofiling",
      );
      log(result.toString());

      String? token = await exchangeCodeForToken(extractCodeFromUrl(result) ?? '');
      if (token.isNotEmpty) {
        _accessToken = token;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('spotifyAccessToken', _accessToken!);
        startPeriodicFetch();
      }
      return token;
    } catch (e) {
      isLoadingPlaylist.value = false;
      isLoadingPlaylist.refresh();
      return '';
    }
  }

  String? extractCodeFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.queryParameters['code'];
  }

  Future<String> exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': 'stressprofiling://callback',
        'client_id': 'cf3bc77109b0414899a50d541efdaca5',
        'client_secret': '707db214fe604ce68799717fabe1dcd0',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      log(jsonResponse['access_token'].toString());
      fetchUserPlaylists(jsonResponse['access_token']);
      return jsonResponse['access_token'].toString();
    } else {
      debugPrint('Failed to get token: ${response.body}');
      return '';
    }
  }

  void startPeriodicFetch() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (_accessToken != null) {
        fetchUserPlaylists(_accessToken!);
      }
    });
  }

  Future<void> fetchUserPlaylists(String accessToken) async {
    isLoadingPlaylist.value = true;
    isLoadingPlaylist.refresh();
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/playlists'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      userPlaylist.clear();

      final playlistsData = json.decode(response.body);
      if (playlistsData['items'] != null) {
        for (var playlist in playlistsData['items']) {
          userPlaylist.add(UserPlaylist.fromJson(playlist));
        }
        userPlaylist.refresh();

        await fetchRecentlyPlayed(accessToken);
        isLoadingPlaylist.value = false;
        isLoadingPlaylist.refresh();

        // Automatically store data in Firebase after fetching
        await _storeDataInFirebase();
      }
    } else {
      debugPrint('Failed to fetch playlists: ${response.body}');
    }
  }

  Future<void> fetchRecentlyPlayed(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/player/recently-played'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      recentPlayed.clear();
      final recentlyPlayedData = json.decode(response.body);
      log(recentlyPlayedData['items'].toString());
      if (recentlyPlayedData['items'] != null) {
        for (var item in recentlyPlayedData['items']) {
          if (recentPlayed.length < 5) {
            recentPlayed.add(RecentPlayed.fromJson(item));
          } else {
            break;
          }
        }
        recentPlayed.refresh();
      } else {
        debugPrint('No recently played tracks found.');
      }
    } else {
      debugPrint('Failed to fetch recently played tracks: ${response.body}');
    }
  }

  Future<void> _storeDataInFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Retrieve and update playlists without duplicates
        final playlistDoc = await userDoc.collection('playlists').doc('user_playlists').get();
        List<dynamic> existingPlaylists = playlistDoc.exists && playlistDoc.data()?['playlists'] != null
            ? List.from(playlistDoc.data()?['playlists'])
            : [];

        // Convert existing playlists to a set of IDs to check for duplicates
        Set<String> existingPlaylistIds = existingPlaylists
            .map((e) => e['playlistId'] as String)
            .toSet();

        // Filter out any duplicate playlists based on playlistId
        List<Map<String, dynamic>> newPlaylists = userPlaylist
            .where((playlist) => !existingPlaylistIds.contains(playlist.playlistId))
            .map((playlist) => playlist.toJson())
            .toList();

        // Add only non-duplicate playlists
        existingPlaylists.addAll(newPlaylists);

        await userDoc.collection('playlists').doc('user_playlists').set({
          'playlists': existingPlaylists,
        }, SetOptions(merge: true));

        // Retrieve and update recently played tracks without duplicates
        final recentTracksDoc = await userDoc.collection('recently_played').doc('recent_tracks').get();
        List<dynamic> existingRecentTracks = recentTracksDoc.exists && recentTracksDoc.data()?['recently_played'] != null
            ? List.from(recentTracksDoc.data()?['recently_played'])
            : [];

        // Convert existing recent tracks to a set of track names to check for duplicates
        Set<String> existingTrackNames = existingRecentTracks
            .map((e) => e['trackName'] as String)
            .toSet();

        // Filter out any duplicate recently played tracks based on trackName
        List<Map<String, dynamic>> newRecentTracks = recentPlayed
            .where((track) => !existingTrackNames.contains(track.trackName))
            .map((track) => track.toJson())
            .toList();

        // Add only non-duplicate recent tracks
        existingRecentTracks.addAll(newRecentTracks);

        await userDoc.collection('recently_played').doc('recent_tracks').set({
          'recently_played': existingRecentTracks,
        }, SetOptions(merge: true));

        debugPrint('Data successfully stored in Firestore with old data preserved and duplicates avoided');
      }
    } catch (e) {
      debugPrint('Failed to store/update data in Firebase: $e');
    }
  }


  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}