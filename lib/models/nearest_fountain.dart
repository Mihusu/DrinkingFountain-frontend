class NearestFountain {
  final int id;
  final double distance;
  final double longitude;
  final double latitude;
  String? address;
  final String type;
  final double score;

  NearestFountain({
    required this.id,
    required this.distance,
    required this.longitude,
    required this.latitude,
    required this.type,
    required this.score,
    String? address,
  });

  factory NearestFountain.fromJson(Map<String, dynamic> json) {
    return NearestFountain(
      id: json['id'] as int,
      distance: (json['distance'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      type: json['longitude'].toString(),
      score: (json['score'] as num).toDouble(),
    );
  }
}
