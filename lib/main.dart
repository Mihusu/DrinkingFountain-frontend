// lib/main.dart
import 'package:flutter/material.dart';
import 'package:toerst/screens/map/map_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.dotenv.load(fileName: "assets/.env");
    runApp(const MyApp());
  } catch (error, stackTrace) {
    print('Error: $error');
    print('StackTrace: $stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MapScreen(),
      );
}
