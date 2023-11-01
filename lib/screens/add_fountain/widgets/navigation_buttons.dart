// navigation_buttons.dart

import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/standard_button.dart';

/// This file contains the Next and Previous navigation buttons used in the MultiStepForm.

// First, the NextButton

/// A button that indicates progression to the next step in a form or process.
class NextButton extends StatelessWidget {
  final VoidCallback onNext;
  final bool enabled;

  const NextButton({
    super.key,
    required this.onNext,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return StandardButton(
      label: 'Next',
      onPressed:
          enabled ? onNext : () {}, // Providing an empty function when disabled
      backgroundColor: enabled ? (secondaryButtonColor) : Colors.grey,
      borderColor: enabled ? (secondaryButtonBorderColor) : Colors.grey[400]!,
      textColor: enabled ? (secondaryButtonTextColor) : Colors.grey[600]!,
    );
  }
}

// Spacer for readability
// Next, the PreviousButton

/// A button that indicates regression to the previous step in a form or process.
class PreviousButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PreviousButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardButton(
      label: 'Previous',
      onPressed: onPressed,
      backgroundColor: tertiaryButtonColor,
      borderColor: tertiaryButtonBorderColor,
      textColor: tertiaryButtonTextColor,
    );
  }
}
