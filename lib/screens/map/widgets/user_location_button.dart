// lib/screens/map/widgets/user_location_button.dart

import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/general_floating_action_button.dart';

class UserLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UserLocationButton({required this.onPressed, Key? key})
      : super(key: key);

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

/*

// File: lib/screens/map_screen/widgets/location_action_button.dart
import 'package:flutter/material.dart';
import 'package:toerst/widgets/general_floating_action_button.dart';

class LocationActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double screenHeight;
  final double sheetPosition;

  const LocationActionButton(required Future<void> Function() onPressed, {
    required this.onPressed,
    required this.screenHeight,
    required this.sheetPosition,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (sheetPosition * screenHeight) - 70,
      right: 14,
      child: sheetPosition != 0.1
          ? GeneralFloatingActionButton(
              onPressed: onPressed,
              iconData: Icons.my_location,
              backgroundColor: Colors.black,
            )
          : Container(),
    );
  }
}
*/
