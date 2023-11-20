import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toerst/screens/add_fountain/widgets/fountain_rating_bar.dart';
import 'package:toerst/screens/add_fountain/widgets/text_input_field.dart';
import 'package:toerst/screens/login/login_screen.dart';
import 'package:toerst/screens/view_fountain/view_fountain_screen.dart';
import 'package:toerst/services/network_service.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/standard_button.dart';

class CreateReviewScreen extends StatefulWidget {
  final int fountainId;

  const CreateReviewScreen({required this.fountainId, super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<CreateReviewScreen> {
  double rating = 3;
  String review = "";
  String errorMessage = "";
  final secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkUserLoginStatus();
  }

  Future<void> checkUserLoginStatus() async {
    String? jwt = await secureStorage.read(key: "JWT");

    if (jwt == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void _setRating(double givenRating) {
    setState(() {
      rating = givenRating;
    });
  }

  void _setReview(String userReview) {
    setState(() {
      review = userReview;
    });
  }

  Future<void> createNewReview() async {
    String? jwt = await secureStorage.read(key: "JWT");

    Map data = {
      'text': review,
      'stars': rating,
      'base64Images': [],
      'type': "FILLING", // Type of the fountain (e.g., 'FILLING' or 'DRINKING')
      'drinkingFountainId': widget.fountainId,
    };

    var body = json.encode(data);

    NetworkService networkService = NetworkService();
    final statusCode = await networkService.createNewReview(jwt, body);

    if (statusCode == 200) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FocusFountainScreen(
                    fountainId: widget.fountainId,
                  )),
          (route) => route
              .isFirst, // This condition removes all screens except the first (mapScreen)
        );
      }
    } else {
      setState(() {
        errorMessage = "Something went wrong"; // Set error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: backToMapButtonIconColor,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            // Add your review content here
            const Text(
              'New Review',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 10),
            FountainRatingBar(onRatingChanged: _setRating),
            const SizedBox(height: 50),
            Flexible(
              child: CustomTextField(
                  charLimit: 200, onReviewSubmitted: _setReview),
            ),
            const SizedBox(height: 25),
            StandardButton(
              label: 'Submit',
              onPressed: () async {
                // Connect here to Backend perhaps
                createNewReview();
              },
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            if (errorMessage.isNotEmpty) // Display error message conditionally
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
