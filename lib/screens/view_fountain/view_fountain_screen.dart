import 'package:flutter/material.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FocusFountainScreen extends StatelessWidget {
  final FlutterSecureStorage secureStorage;
  final int fountainId;

  const FocusFountainScreen({
    required this.secureStorage,
    required this.fountainId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Contains the build in back button
        title: const Text('Fountain'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Fountain: $fountainId',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
