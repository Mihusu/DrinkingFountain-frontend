// lib/widgets/bottom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:toerst/screens/login/login_screen.dart';
import 'package:toerst/screens/map/widgets/add_fountain_button.dart';
import 'package:toerst/screens/profile/profile_screen.dart';
import 'package:toerst/themes/app_colors.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomBottomAppBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() action; // Use Function() type for no-arg callbacks.
  final FlutterSecureStorage secureStorage;

  const CustomBottomAppBar({
    required this.icon,
    required this.text,
    required this.action,
    required this.secureStorage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 0.0,
      color: bottomAppBarColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(icon, color: bottomAppBarIconColor),
                  onPressed: action,
                ),
                Text(text,
                    style: const TextStyle(
                        color: bottomAppBarTextColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 48.0), // Placeholder for the button
                Text("Add Fountain",
                    style: TextStyle(
                        color: bottomAppBarTextColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.account_circle,
                      color: bottomAppBarIconColor),
                  onPressed: () async {
                    final authToken = await secureStorage.read(key: 'JWT');

                    if (authToken != null) {
                      if (context.mounted) {
                        //Check if context is still available
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              secureStorage: secureStorage,
                            ),
                          ),
                        );
                      }
                    } else {
                      if (!context.mounted) {
                        return; //Check if context is still available
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    }
                  },
                ),
                const Text("Profile",
                    style: TextStyle(
                        color: bottomAppBarTextColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
