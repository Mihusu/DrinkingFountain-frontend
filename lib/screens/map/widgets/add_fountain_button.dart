// PATH: lib/screens/map/widgets/add_fountain_button.dart
import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/step_1_add_photo_screen.dart';
import 'package:toerst/widgets/general_floating_action_button.dart';
import 'package:toerst/themes/app_colors.dart';

class AddFountainButton extends StatelessWidget {
  const AddFountainButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralFloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddPhotoScreen(),
            settings: const RouteSettings(
              name: '/add_photo_screen',
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      backgroundColor: addFountainButtonColor,
      borderColor: addFountainButtonBorderColor,
      borderWidth: 3.0,
      padding: 25.0,
      child: Transform.rotate(
        angle: 3.14159, // pi = 3.14159 radians is 180 degrees
        child: const Icon(
          Icons.add_location_alt_rounded,
          size: 36.0,
          color: addFountainButtonIconColor,
        ),
      ),
    );
  }
}
