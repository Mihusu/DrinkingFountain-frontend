// PATH: lib/screens/add_fountain/step_1_add_photo_screen.dart

import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/add_fountain_screen.dart';
import 'package:toerst/screens/add_fountain/step_5_add_review.dart';
import 'package:toerst/screens/add_fountain/widgets/address_typing_field.dart';

class AddLocationScreen extends StatelessWidget {
  const AddLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddFountainScreen(
      content: AddressTypingField(),
      currentStep: 3, // We are on step 4
      stepText:
          "Leave a written review if you wish.", // Text for this specific step
      nextDestination:
          const AddTextualReviewScreen(), // The screen to navigate to when 'Next' is pressed
    );
  }
}
