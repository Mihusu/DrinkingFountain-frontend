// PATH: lib/screens/add_fountain/widgets/previous_button.dart

import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/standard_button.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardButton(
      label: 'Previous',
      onPressed: () {
        Navigator.pop(context); // Go to the prevois page in the stack
      },
      backgroundColor: tertiaryButtonColor,
      borderColor: tertiaryButtonBorderColor,
      textColor: tertiaryButtonTextColor,
    );
  }
}
