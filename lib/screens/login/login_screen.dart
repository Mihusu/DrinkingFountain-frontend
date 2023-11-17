import 'package:flutter/material.dart';

// Http
import 'package:http/http.dart' as http;
import 'dart:convert';

//env file
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toerst/screens/add_fountain/widgets/back_to_map_button.dart';
import 'package:toerst/screens/profile/profile_screen.dart';
import 'package:toerst/screens/register/register_screen.dart';
import 'package:toerst/screens/reset_password/reset_password_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        //Contains the build in back button
        title: const Text('Login', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: const BackToMapButton(),
        leadingWidth: 107,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Conditional widget to show "Login Failed" message
            if (_loginFailed)
              const Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text('Login Failed. Please provide valid credentials',
                    style: TextStyle(fontWeight: FontWeight.w600,
                    color: Colors.red)),
                  ),
                ],
              ),
            // Username Input Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
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
            const SizedBox(height: 20),
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
              width: 150,
            ),
            const SizedBox(height: 30), // Add some space between the button and the text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don’t have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the register screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Register here',
                    style: TextStyle(
                      color: Colors.blue, 
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Forgot your password? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    // Navigate to the register screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordRequest(),
                      ),
                    );
                  },
                  child: const Text(
                    'Reset here',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}