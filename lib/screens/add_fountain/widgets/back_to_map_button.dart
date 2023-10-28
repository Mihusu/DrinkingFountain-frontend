import 'package:flutter/material.dart';
import 'package:toerst/main.dart';
import 'package:toerst/themes/app_colors.dart'; // Assuming MapScreen is defined in this file

class BackToMapButton extends StatelessWidget {
  const BackToMapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: 150, // Specify a width for the button
        height: 50, // Specify a height for the button
        child: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const MapScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, -1.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

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
        ),
      ),
    );
  }
}
