import 'package:flutter/material.dart';

// Http
import 'package:http/http.dart' as http;
import 'dart:convert';

//env file
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toerst/screens/profile/profile_screen.dart';
import 'package:toerst/widgets/standard_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loginFailed = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final secureStorage = const FlutterSecureStorage();

  Future<bool> login() async {
    final apiKey = dotenv.env['API_KEY'] ?? 'default';
    final ip = dotenv.env['BACKEND_IP'] ?? 'default';

    final headers = <String, String>{
      'Api-Key': apiKey,
      'Content-Type': 'application/json'
    };

    final url = 'http://$ip/auth/login';

    Map data = {
      'username': usernameController.text,
      'password': passwordController.text
    };

    var body = json.encode(data);

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final String jwtToken = response.body;
      await secureStorage.write(key: "JWT", value: jwtToken);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_loginFailed);

    return Scaffold(
      appBar: AppBar(
        //Contains the build in back button
        title: const Text('Login Screen'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Username Input Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),

            // Password Input Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),

            // Login Button
            StandardButton(
              onPressed: () async {
                bool loginSuccess = await login();
                if (loginSuccess) {
                  if (!context.mounted) {
                    return; //Check if context is still available
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        secureStorage: secureStorage,
                      ),
                    ),
                  ); // Navigate back on success
                } else {
                  setState(() {
                    _loginFailed = true; // Handle login failure
                  });
                }
              },
              label: 'Login',
              textColor: Colors.white,
              backgroundColor: Colors.black,
              width: 120,
            ),
            // Conditional widget to show "Login Failed" message
            if (_loginFailed)
              const Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text('Login Failed'),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
