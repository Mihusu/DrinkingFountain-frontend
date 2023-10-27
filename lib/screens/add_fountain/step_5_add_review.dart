// PATH: lib/screens/add_fountain/step_1_add_photo_screen.dart

import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/add_fountain_screen.dart';
import 'package:toerst/screens/add_fountain/step_1_add_photo_screen.dart';
import 'package:toerst/screens/add_fountain/widgets/text_input_field.dart';

class AddTextualReviewScreen extends StatelessWidget {
  const AddTextualReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddFountainScreen(
      content: CustomTextField(
          charLimit:
              200), // The widget that would be in the center of the screen
      currentStep: 4, // We are on step 4
      stepText:
          "Leave a written review if you wish.", // Text for this specific step
      nextDestination:
          const AddPhotoScreen(), // The screen to navigate to when 'Next' is pressed
    );
  }
}
