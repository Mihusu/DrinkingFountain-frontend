// PATH: lib/screens/add_fountain/widgets/next_button.dart

import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/standard_button.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onNext;

  const NextButton({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return StandardButton(
      label: 'Next',
      onPressed: onNext,
      backgroundColor: secondaryButtonColor,
      borderColor: secondaryButtonBorderColor,
      textColor: secondaryButtonTextColor,
    );
  }
}
