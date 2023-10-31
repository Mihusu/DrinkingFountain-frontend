class FountainLocation {
  final int id;
  final double latitude;
  final double longitude;
  final double distance;

  FountainLocation(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.distance});

  factory FountainLocation.fromJson(Map<String, dynamic> json) {
    return FountainLocation(
        id: json['id'] as int,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        distance: (json['distance'] as num).toDouble());
  }
}
