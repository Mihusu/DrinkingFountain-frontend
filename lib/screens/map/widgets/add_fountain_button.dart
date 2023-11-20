// PATH: lib/screens/map/widgets/add_fountain_button.dart
import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/multi_step_form_screen.dart';
import 'package:toerst/screens/login/login_screen.dart';
import 'package:toerst/services/role_state_service.dart';
import 'package:toerst/widgets/general_floating_action_button.dart';
import 'package:toerst/themes/app_colors.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddFountainButton extends StatelessWidget {
  final FlutterSecureStorage secureStorage;
  final RoleService roleService = RoleService();

  AddFountainButton({required this.secureStorage, super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralFloatingActionButton(
      onPressed: () async {
        bool isloggedIN = await roleService.isUserLoggedIn(secureStorage);

        if (isloggedIN) {
          if (context.mounted) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const MultiStepForm(),
                settings: const RouteSettings(
                  name: '/add_photo_screen',
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          }
        } else {
          if (!context.mounted) {
            return; // Check if context is still available
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
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
