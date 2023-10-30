// lib/screens/add_fountain/widgets/back_to_map_button.dart

import 'package:flutter/material.dart';
import 'package:toerst/main.dart';
import 'package:toerst/themes/app_colors.dart';

class BackToMapButton extends StatelessWidget {
  const BackToMapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MapScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Adjusted the begin and end offsets for the slide up transition
              var begin = Offset(0.0, 1.0); // Start from the bottom
              var end = Offset(0.0, 0.0); // End at the top
              var curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: backToMapButtonIconColor,
            ),
            Text(
              "Show Map",
              style: TextStyle(
                color: backToMapButtonTextColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
