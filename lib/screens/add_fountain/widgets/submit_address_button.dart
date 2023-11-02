import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/standard_button.dart';

class SubmitAddressButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitAddressButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return StandardButton(
      borderColor: secondaryButtonBorderColor,
      backgroundColor: secondaryButtonColor,
      textColor: secondaryButtonTextColor,
      label: 'Submit Address',
      onPressed: onPressed,
    );
  }
}
