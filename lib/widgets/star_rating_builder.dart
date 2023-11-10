// PATH: lib/widgets/rating_stars.dart

import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart'; // Importing star colors

class StarRatingBuilder extends StatelessWidget {
  final int ratingAsInt;
  final int maxRating;
  final bool
      showRatingAsDouble; // Choose if you want show the rating as a double.

  const StarRatingBuilder({
    super.key,
    required this.ratingAsInt,
    this.maxRating = 5,
    this.showRatingAsDouble = true,
  });

  @override
  Widget build(BuildContext context) {
    int rating = ratingAsInt;

    List<Widget> starsRow = [];

    for (int i = 1; i <= maxRating; i++) {
      if (i <= rating) {
        starsRow
            .add(const Icon(Icons.star, color: starFilledColor)); // Filled star
      } else {
        starsRow.add(const Icon(Icons.star_border,
            color: starBorderColor)); // Empty star
      }
    }

    if (showRatingAsDouble) {
      starsRow.add(Text(ratingAsInt.toDouble().toString()));
    }
    return Row(children: starsRow);
  }
}
