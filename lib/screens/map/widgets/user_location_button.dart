// lib/screens/map/widgets/user_location_button.dart

import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/general_floating_action_button.dart';

class UserLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UserLocationButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralFloatingActionButton(
      onPressed: onPressed,
      backgroundColor: secondaryButtonColor,
      borderColor: secondaryButtonBorderColor,
      borderWidth: 3.0,
      padding: 25.0,
      child: const Icon(
        Icons.location_city_rounded,
        size: 36.0,
      ),
    );
  }
}