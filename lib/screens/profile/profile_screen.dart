// PATH: 
import 'package:flutter/material.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toerst/screens/approve_fountain/approve_screen.dart';
import 'package:toerst/services/user_service.dart';
import 'package:toerst/widgets/standard_button.dart';

class ProfileScreen extends StatefulWidget {
  final FlutterSecureStorage secureStorage;

  const ProfileScreen({
    required this.secureStorage,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String> _username;
  late UserService _userService;

  @override
  void initState() {
    super.initState();
    _userService = UserService(); // Instantiate UserService here
    _username = _userService.getUsername();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.black,
        ),
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _username,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show an error message if fetching fails
            } else {
              final username = snapshot.data ?? 'Default Username';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // const Text(
                  //   'johndoe@email.com',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceAround, // You can adjust alignment as needed
                      children: [
                        StandardButton(
                          onPressed: () async {
                            await widget.secureStorage.delete(key: "JWT");
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          label: 'Log out',
                          textColor: Colors.black,
                          borderColor: Colors.black,
                        ),
                        const SizedBox(height: 20),
                        StandardButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApproveScreen(
                                  
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
              );
            }
          },
        ),
      ),
    );
  }
}
