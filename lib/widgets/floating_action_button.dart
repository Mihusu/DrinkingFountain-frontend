// This is the AddFountain Button
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: FloatingActionButton(
          backgroundColor: addFountainButtonColor,
          onPressed: () {},
          elevation: 0.0,
          highlightElevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(
                color: addFountainButtonBorderColor, width: 3.0),
          ),
          child: Transform.rotate(
            angle: pi,
            child: const Icon(
              Icons.add_location_alt_rounded,
              size: 36.0,
              color: addFountainButtonIconColor,
            ),
          ),
        ),
      ),
    );
  }
}
