import 'package:flutter/material.dart';

// Http
import 'package:http/http.dart' as http;
import 'dart:convert';

//env file
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  bool _loginFailed = false; 
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();

  Future<bool> login() async {
    final String ip = dotenv.env['BACKEDN_IP'] ?? 'default';
    final apiKey = dotenv.env['API_KEY'] ?? 'default';
    print(apiKey);

    final headers = <String, String>{'Api-Key': apiKey,
     'Content-Type': 'application/json'};
    final url = 'http://$ip/auth/login';


    Map data = {
    'username': usernameController.text,
    'password': passwordController.text
    };

    var body = json.encode(data);

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final String jwtToken = response.body;
      await storage.write(key: "JWT", value: jwtToken);
      return true;
    } else {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
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
                  labelText:  'Username',
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
            ElevatedButton( 
              onPressed: () async {
                bool loginSuccess = await login();
                if (loginSuccess) {
                  Navigator.pop(context); // Navigate back on success
                } else {  
                    _loginFailed = true; // Handle login failure
                }
              },
              child: const Text('Login'),
            ),
            // Conditional widget to show "Login Failed" message
            if (_loginFailed)
                const Center(
                child: Text('Login Failed'),
            ),
          ],
        ),
      ),
    );
  }
}
