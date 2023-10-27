// PATH: lib/screens/add_fountain/widgets/capture_photo_button.dart
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/screens/add_fountain/take_picture_screen.dart';

class CapturePhotoButton extends StatefulWidget {
  const CapturePhotoButton({super.key});

  @override
  _CapturePhotoButtonState createState() => _CapturePhotoButtonState();
}

class _CapturePhotoButtonState extends State<CapturePhotoButton> {
  File? capturedImageFile;

  Future<void> onCapturePhoto() async {
    // Fetch the list of available cameras.
    final cameras = await availableCameras();

    // Check if there are any cameras available.
    if (cameras.isNotEmpty) {
      // Pass the first camera to TakePictureScreen.
      final File? imageFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: cameras.first),
        ),
      );
      if (imageFile != null) {
        setState(() {
          capturedImageFile = imageFile;
        });
        if (kDebugMode) {
          print('Image File Path: ${capturedImageFile?.path}');
        } // Diagnostic Snippet 1
        capturedImageFile?.exists().then((exists) {
          // Diagnostic Snippet 3
          if (kDebugMode) {
            print('File Exists: $exists');
          }
        });
      }
    } else {
      // Handle the case where no cameras are available.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No cameras available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCapturePhoto,
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: capturedImageFile == null
            ? const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 8),
                    Text('Capture Photo'),
                  ],
                ),
              )
            : _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (kDebugMode) {
      print('Rendering Image');
    } // Diagnostic Snippet 2
    return Image.file(capturedImageFile!);
  }
}






/*
class CapturePhotoButton extends StatefulWidget {
  @override
  _CapturePhotoButtonState createState() => _CapturePhotoButtonState();
}

class _CapturePhotoButtonState extends State<CapturePhotoButton> {
  Image? capturedImage;

  Future<void> onCapturePhoto() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // Navigate to take_picture_screen.dart and await the captured image
    final Image? image = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: firstCamera,
        ),
      ),
    );
    if (image != null) {
      setState(() {
        capturedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCapturePhoto, // Always allow navigation to TakePictureScreen
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: capturedImage ??
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Capture Photo'),
                ],
              ),
            ),
      ),
    );
  }
}
*/