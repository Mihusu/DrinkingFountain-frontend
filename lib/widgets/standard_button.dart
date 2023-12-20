import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double width; // set as non-nullable
  final double height; // set as non-nullable

  const StandardButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.black,
    this.width = 150.0, // default width
    this.height = 50.0, // default height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(
              0.0), // Added this line to remove shadow
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          side: MaterialStateProperty.all(BorderSide(color: borderColor)),
          foregroundColor: MaterialStateProperty.all(textColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  30.0), // Set this value high for completely rounded edges
            ),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
