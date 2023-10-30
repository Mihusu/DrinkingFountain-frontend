/*

// PATH: lib/screens/add_fountain/step_3_rate_fountain.dart

import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/add_fountain_screen.dart';
import 'package:toerst/screens/add_fountain/step_4_add_location_screen.dart';
import 'package:toerst/screens/add_fountain/step_5_add_review.dart';
import 'package:toerst/screens/add_fountain/widgets/fountain_rating_bar.dart';

class RateFountainScreen extends StatelessWidget {
  const RateFountainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddFountainScreen(
      content:
          FountainRatingBar(), // The widget that would be in the center of the screen
      currentStep: 2,
      stepText:
          "How would you rate this drinking fountain?", // Text for this specific step
      nextDestination:
          AddLocationScreen(), // The screen to navigate to when 'Next' is pressed
    );
  }
}
*/