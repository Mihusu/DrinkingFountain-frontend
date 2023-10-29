class NearestFountain {
  final int id;
  final double distance;
  final String type;
  final double score;

  NearestFountain(
      {required this.id,
      required this.distance,
      required this.type,
      required this.score});

  factory NearestFountain.fromJson(Map<String, dynamic> json) {
    return NearestFountain(
        id: json['id'] as int,
        distance: (json['distance'] as num).toDouble(),
        type: json['longitude'].toString(),
        score: (json['score'] as num).toDouble());
  }
}
