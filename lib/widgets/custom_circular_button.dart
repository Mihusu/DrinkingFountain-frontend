// PATH: lib/widgets/custom_circular_button.dart

import 'package:flutter/material.dart';

class CustomCircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final double size;

  const CustomCircularButton({
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.size = 60.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        padding: EdgeInsets.all(size / 4), // Adjust padding based on the size
        minimumSize: Size(size, size),
        fixedSize: Size(size, size),
      ),
      child: Icon(icon, color: Colors.white, size: size / 2),
    );
  }
}
