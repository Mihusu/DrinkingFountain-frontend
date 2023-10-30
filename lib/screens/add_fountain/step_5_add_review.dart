/*

// PATH: lib/screens/add_fountain/step_1_add_photo_screen.dart

import 'package:flutter/material.dart';
import 'package:toerst/main.dart';
import 'package:toerst/screens/add_fountain/add_fountain_screen.dart';
import 'package:toerst/screens/add_fountain/multi_step_form.dart';
import 'package:toerst/screens/add_fountain/step_1_add_photo_screen.dart';
import 'package:toerst/screens/add_fountain/widgets/text_input_field.dart';

class AddTextualReviewScreen extends StatelessWidget {
  const AddTextualReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddFountainScreen(
      // Removed 'const' here
      content: CustomTextField(charLimit: 200),
      currentStep: 4,
      stepText: "Leave a written review if you wish.",
      nextDestination: MultiStepForm(),
    );
  }
}
*/