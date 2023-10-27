class Fountain {
  String? imagePath; // path to the image of the fountain
  String type; // type of the fountain
  double rating; // rating from flutter_rating_bar
  double latitude; // latitude of the fountain
  double longitude; // longitude of the fountain
  String review; // textual review

  Fountain({
    this.imagePath,
    required this.type,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.review,
  });
}
