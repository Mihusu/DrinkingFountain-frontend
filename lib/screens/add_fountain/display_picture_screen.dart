// PATH: lib/screens/add_fountain/display_picture_screen.dart

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:toerst/widgets/custom_circular_button.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final CameraDescription camera;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.camera,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2, // Adjust this value to control space above the image
            child: Container(), // Empty container
          ),
          Expanded(
            flex: 3, // Adjust this value to control space for the image
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Image.file(File(imagePath)),
            ),
          ),
          Expanded(
            flex: 2, // Adjust this value to control space for the buttons
            child: Center(
              // Center the row of buttons vertically in this space
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Retake button
                    CustomCircularButton(
                      onPressed: () {
                        // Pop the current screen to go back to the TakePictureScreen
                        Navigator.pop(context);
                      },
                      icon: Icons.replay,
                      backgroundColor: Colors.yellow,
                    ),
                    const SizedBox(width: 30), // Space between buttons
                    // 'Use this photo' button
                    CustomCircularButton(
                      onPressed: () {
                        // Pop the current screen and return the image file
                        Navigator.pop(context, File(imagePath));
                      },
                      icon: Icons.check,
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
