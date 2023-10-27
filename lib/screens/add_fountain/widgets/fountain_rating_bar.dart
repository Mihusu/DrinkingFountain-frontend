import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FountainRatingBar extends StatefulWidget {
  const FountainRatingBar({super.key});

  @override
  _FountainRatingBar createState() => _FountainRatingBar();
}

class _FountainRatingBar extends State<FountainRatingBar> {
  double _rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
        if (kDebugMode) {
          print(_rating);
        }
      },
    );
  }
}
