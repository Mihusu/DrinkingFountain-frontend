import 'dart:async';
import 'dart:convert';

// Http
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toerst/screens/login/login_screen.dart';
import 'package:toerst/widgets/standard_button.dart';

class ResetPasswordRequest extends StatefulWidget {
  const ResetPasswordRequest({super.key});

  @override
  _ResetPasswordRequestState createState() => _ResetPasswordRequestState();
}

class _ResetPasswordRequestState extends State<ResetPasswordRequest> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifierController = TextEditingController();
  String repeatPassword = '';
  bool _showResetFailedMessage = false;
  bool _showPasswordMismatchMessage = false;
  bool _resetPasswordFailed = false;
  bool _showPasswordRequirementFailedMessage = false;
  
  Future<bool> resetPassword() async {
    final apiKey = dotenv.env['API_KEY'] ?? 'default';
    final ip = dotenv.env['BACKEND_IP'] ?? 'default';

    final headers = <String, String>{
      'Api-Key': apiKey,
      'Content-Type': 'application/json'
    };

    final url = 'http://$ip/auth/reset-password';

    Map data = {
      'username': usernameController.text,
      'password': passwordController.text
    };

    var body = json.encode(data);

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

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
        title: const Text('Reset password', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        color: Colors.black,
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Conditional widget to show "Login Failed" message
            if (_resetPasswordFailed)
               Column(
                children: [
                  const SizedBox(height: 20),
                  Visibility(
                    visible: _showPasswordMismatchMessage || _showResetFailedMessage || _showPasswordRequirementFailedMessage,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_showPasswordMismatchMessage)
                            const Text(
                              "The password don't match",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                            ),
                          if (_showResetFailedMessage)
                            const Text(
                              'Reset password Failed. Please provide valid credentials',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                            ),
                          if (_showPasswordRequirementFailedMessage)
                            const Text(
                              'Password is too short',
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
            // Reset password Button
            StandardButton(
              onPressed: () async {
                if (passwordController.text == passwordVerifierController.text && passwordController.text.length >= 8 && passwordVerifierController.text.length >= 8) {
                  bool resetPasswordSuccess = await resetPassword();
                  if (resetPasswordSuccess) {
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
                      _resetPasswordFailed = true; // Handle password failure
                      _showResetFailedMessage = true; // Show the error message temporarily
                      _showPasswordRequirementFailedMessage = false;
                    });

                    // Set a timer to hide the error message after a certain duration
                    Timer(const Duration(seconds: 4), () {
                      if (context.mounted) {
                        setState(() {
                          _showResetFailedMessage = false;
                        });
                      }
                    });
                  }
                } else if (passwordController.text.length < 8 || passwordVerifierController.text.length < 8) {
                  setState(() {
                    _showPasswordRequirementFailedMessage = true;
                    _showPasswordMismatchMessage = false;
                    _showResetFailedMessage = false;
                    _resetPasswordFailed = true;
                  });

                  // Set a timer to hide the password mismatch error after a certain duration
                  Timer(const Duration(seconds: 3), () {
                    if (context.mounted) {
                      setState(() {
                        _showPasswordRequirementFailedMessage = false;
                      });
                    }
                  });

                } else {
                  setState(() {
                    _showPasswordMismatchMessage = true; // Show the password mismatch error
                    _showResetFailedMessage = false; // Reset password failed error
                    _showPasswordRequirementFailedMessage = false;
                  });

                  // Set a timer to hide the password mismatch error after a certain duration
                  Timer(const Duration(seconds: 3), () {
                    if (context.mounted) {
                      setState(() {
                        _showPasswordMismatchMessage = false;
                      });
                    }
                  });  
                }
              },
              label: 'Confirm',
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