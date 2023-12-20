// File: lib/widgets/general_floating_action_button.dart
import 'package:flutter/material.dart';

class GeneralFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child; // Pass Icon() here if needed
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double padding;

  const GeneralFloatingActionButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor = Colors.blue,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.padding = 0.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          elevation: 0.0,
          highlightElevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
