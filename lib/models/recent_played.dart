class RecentPlayed {
  final String trackName;
  final List<Artist> artistNames;

  RecentPlayed({
    required this.trackName,
    required this.artistNames,
  });

  // Convert the RecentPlayed object to JSON
  Map<String, dynamic> toJson() {
    return {
      'trackName': trackName,
      'artistNames': artistNames.map((artist) => artist.toJson()).toList(),
    };
  }

  factory RecentPlayed.fromJson(Map<String, dynamic> json) {
    var track = json['track'];
    var artistList = (track != null && track['artists'] != null)
        ? (track['artists'] as List)
        .map((artistJson) => Artist.fromJson(artistJson))
        .toList()
        : <Artist>[];

    return RecentPlayed(
      trackName: track != null ? track['name'] ?? '' : '',
      artistNames: artistList,
    );
  }
}

class Artist {
  final String id;
  final String name;

  Artist({
    required this.id,
    required this.name,
  });

  // Convert the Artist object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
