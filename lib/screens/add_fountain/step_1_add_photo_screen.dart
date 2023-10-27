// PATH: lib/screens/add_fountain/step_1_add_photo_screen.dart

import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/add_fountain_screen.dart';
import 'package:toerst/screens/add_fountain/widgets/capture_photo_button.dart';
import 'package:toerst/screens/add_fountain/step_2_select_type_screen.dart';

class AddPhotoScreen extends StatelessWidget {
  const AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddFountainScreen(
      content:
          CapturePhotoButton(), // The widget that would be in the center of the screen
      currentStep: 0, // We are on step 1
      stepText:
          "Capture a photo of the fountain.", // Text for this specific step
      nextDestination:
          SelectTypeScreen(), // The screen to navigate to when 'Next' is pressed
      showPreviousButton:
          false, // Hide the 'Previous' button for the first step
    );
  }
}
