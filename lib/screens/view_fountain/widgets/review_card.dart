import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toerst/models/viewed_fountain.dart';

class ReviewCard extends StatelessWidget {
  final ReviewDTO review;

  ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  review.type,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  review.text,
                ),
                Row(
                  children: List.generate(
                    review.stars,
                    (index) =>
                        Icon(Icons.star, size: 20.0, color: Colors.black),
                  ),
                ),
                Text(
                  "Posted on: ${review.createdAt.toLocal()}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
