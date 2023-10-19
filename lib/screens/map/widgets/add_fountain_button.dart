// File: lib/screens/map_screen/widgets/add_fountain_button.dart
import 'package:flutter/material.dart';
import 'package:toerst/widgets/general_floating_action_button.dart';
import 'package:toerst/themes/app_colors.dart';

class AddFountainButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddFountainButton({required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralFloatingActionButton(
      onPressed: onPressed,
      backgroundColor: addFountainButtonColor,
      borderColor: addFountainButtonBorderColor,
      borderWidth: 3.0,
      padding: 25.0,
      child: Transform.rotate(
        angle: 3.14159, // pi = 3.14159 radians is 180 degrees
        child: const Icon(
          Icons.add_location_alt_rounded,
          size: 36.0,
        ),
      ),
    );
  }
}
