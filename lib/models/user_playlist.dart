import 'dart:developer';

class UserPlaylist {
  final String playlistId;
  final String playlistName;

  UserPlaylist({
    required this.playlistId,
    required this.playlistName,
  });

  // Optional: A method to convert the model to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'playlistId': playlistId,
      'playlistName': playlistName,
    };
  }

  // Optional: A factory method to create a Playlist instance from a map
  factory UserPlaylist.fromJson(Map<String, dynamic> json) {
    return UserPlaylist(
      playlistId: json['id'] ?? '', // Use an empty string as default
      playlistName: json['name'] ?? '', // Use an empty string as default
    );
  }
}