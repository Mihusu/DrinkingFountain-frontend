import 'package:flutter/material.dart';
import 'package:toerst/models/viewed_fountain.dart';
import 'package:toerst/widgets/star_rating_builder.dart';

class ReviewCard extends StatelessWidget {
  final ReviewDTO review;
  final double screenHeight;

  const ReviewCard({
    required this.review,
    required this.screenHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 3, // Add elevation for a shadow effect
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    // NOTE: The desired size of the star icons before was set to 25.0.
                    children: [
                      StarRatingBuilder(
                        ratingAsInt: review.stars,
                        showRatingAsDouble: false,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    review.text,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Posted on: ${review.createdAt.toLocal()}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
