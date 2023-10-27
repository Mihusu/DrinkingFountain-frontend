// PATH: lib/screens/add_fountain/display_picture_screen.dart

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/take_picture_screen.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final CameraDescription camera;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(imagePath)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to TakePictureScreen to retake the photo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(camera: camera),
                      ),
                    );
                  },
                  child: const Text('Retake'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context, File(imagePath)); // Pop to TakePictureScreen
                    Navigator.pop(
                        context,
                        File(
                            imagePath)); // Pop to AddPhotoScreen with the image file
                  },
                  child: const Text('Use this photo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
