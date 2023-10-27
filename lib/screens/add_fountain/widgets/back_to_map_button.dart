import 'package:flutter/material.dart';
import 'package:toerst/main.dart';
import 'package:toerst/themes/app_colors.dart'; // Assuming MapScreen is defined in this file

class BackToMapButton extends StatelessWidget {
  const BackToMapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
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
