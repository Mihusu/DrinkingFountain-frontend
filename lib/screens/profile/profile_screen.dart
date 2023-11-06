import 'package:flutter/material.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toerst/screens/approve/approve_screen.dart';
import 'package:toerst/screens/approve/approve_screen_detail.dart';
import 'package:toerst/widgets/standard_button.dart';

class ProfileScreen extends StatelessWidget {
  final FlutterSecureStorage secureStorage;

  const ProfileScreen({
    required this.secureStorage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Contians the build in back button
        title: const Text('User Profile'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'johndoe@email.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceAround, // You can adjust alignment as needed
                children: [
                  StandardButton(
                    onPressed: () async {
                      await secureStorage.delete(key: "JWT");
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    label: 'Log out',
                    textColor: Colors.black,
                    borderColor: Colors.black,
                  ),
                  StandardButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FountainSwiper(
                            
                          ),
                        ),
                      ); // Navigate back on success
                    },
                    label: "Fountains",
                    textColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
