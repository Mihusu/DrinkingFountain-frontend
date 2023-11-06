class CurrentFountain {
  final int id;
  final double latitude;
  final double longitude;
  final String type;
  final DateTime createdAt; // Use DateTime instead of ZonedDateTime
  final double score;
  final List<FountainImageDTO> fountainImages;
  final List<ReviewDTO> reviews;

  CurrentFountain({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.createdAt,
    required this.score,
    required this.fountainImages,
    required this.reviews,
  });

  factory CurrentFountain.fromJson(Map<String, dynamic> json) {
    // Use the 'fromMap' method to parse JSON data and create an instance
    return CurrentFountain(
      id: json['id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      score: (json['score'] as num).toDouble(),
      fountainImages: (json['fountainImages'] as List)
          .map((imageJson) => FountainImageDTO.fromJson(imageJson))
          .toList(),
      reviews: (json['reviews'] as List)
          .map((reviewJson) => ReviewDTO.fromJson(reviewJson))
          .toList(),
    );
  }
}

class FountainImageDTO {
  final String base64;

  FountainImageDTO({
    required this.base64,
  });

  factory FountainImageDTO.fromJson(Map<String, dynamic> json) {
    return FountainImageDTO(
      base64: json['imageBase64'] as String,
    );
  }
}

class ReviewDTO {
  final String text;
  final int stars;
  final List<ReviewImageDTO> fountainImages;
  final String type;
  final String username;
  final DateTime createdAt;

  ReviewDTO({
    required this.text,
    required this.stars,
    required this.fountainImages,
    required this.type,
    required this.username,
    required this.createdAt,
  });

  factory ReviewDTO.fromJson(Map<String, dynamic> json) {
    return ReviewDTO(
      text: json['text'] as String,
      stars: json['stars'] as int,
      fountainImages: (json['fountainImages'] as List)
          .map((imageJson) => ReviewImageDTO.fromJson(imageJson))
          .toList(),
      type: json['type'] as String,
      username: json['username'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ReviewImageDTO {
  final String base64;

  ReviewImageDTO({
    required this.base64,
  });

  factory ReviewImageDTO.fromJson(Map<String, dynamic> json) {
    return ReviewImageDTO(
      base64: json['imageBase64'] as String,
    );
  }
}