import 'dart:async';

import 'package:flutter/material.dart';

// Http
import 'package:http/http.dart' as http;
import 'dart:convert';

//env file
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Widgets and screens
import 'package:toerst/screens/login/login_screen.dart';
import 'package:toerst/widgets/standard_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _registerFailed = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifierController = TextEditingController();
  String repeatPassword = '';
  bool showErrorMessage = false;
  bool showPasswordMismatchError = false;


  Future<bool> register() async {
    final apiKey = dotenv.env['API_KEY'] ?? 'default';
    final ip = dotenv.env['BACKEND_IP'] ?? 'default';

    final headers = <String, String>{
      'Api-Key': apiKey,
      'Content-Type': 'application/json'
    };

    final url = 'http://$ip/auth/register';

    Map data = {
      'username': usernameController.text,
      'password': passwordController.text
    };

    var body = json.encode(data);

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Contains the build in back button
        title: const Text('Register'),
        backgroundColor: Colors.black,
        leading: const LoginScreen(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Conditional widget to show "Login Failed" message
            if (_registerFailed)
               Column(
                children: [
                  const SizedBox(height: 20),
                  Visibility(
                    visible: showPasswordMismatchError || showErrorMessage,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (showPasswordMismatchError)
                            const Text(
                              "The password don't match",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                            ),
                          if (showErrorMessage)
                            const Text(
                              'Register Failed. Please provide valid credentials',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            // Username Input Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: usernameController,
                onChanged: (value) {
                  setState(() {
                    repeatPassword = value;
                  });
                },
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
                  hintText: 'Must contain at least 8 characters'  
                ),
              ),
            ),
            // Password Input Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: passwordVerifierController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Repeat password'
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Register Button
            StandardButton(
              onPressed: () async {
                if (passwordController.text == passwordVerifierController.text) {
                  bool registerSuccess = await register();
                  if (registerSuccess) {
                    if (!context.mounted) {
                      return; // Check if context is still available
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ); // Navigate back on success
                  } else {
                    setState(() {
                      _registerFailed = true; // Handle register failure
                      showErrorMessage = true; // Show the error message temporarily
                    });

                    // Set a timer to hide the error message after a certain duration
                    Timer(const Duration(seconds: 3), () {
                      if (context.mounted) {
                        setState(() {
                          showErrorMessage = false;
                        });
                      }
                    });
                  }
                } else {
                  setState(() {
                    showPasswordMismatchError = true; // Show the password mismatch error
                    showErrorMessage = false; // Reset the register failed error
                  });

                  // Set a timer to hide the password mismatch error after a certain duration
                  Timer(const Duration(seconds: 5), () {
                    if (context.mounted) {
                      setState(() {
                        showPasswordMismatchError = false;
                      });
                    }
                  });  
                }
              },
              label: 'Register',
              textColor: Colors.white,
              backgroundColor: Colors.black,
              width: 150,
            ),
          ],
        ),
      ),
    );
  }
}