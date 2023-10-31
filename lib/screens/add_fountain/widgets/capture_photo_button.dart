// PATH: lib/screens/add_fountain/widgets/capture_photo_button.dart

import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/screens/add_fountain/take_picture_screen.dart';

class CapturePhotoButton extends StatefulWidget {
  final String? imageBase64; // Use a base64 string to represent the image
  final Function(String) onImageCaptured;

  const CapturePhotoButton({
    Key? key,
    this.imageBase64,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  _CapturePhotoButtonState createState() => _CapturePhotoButtonState();
}

class _CapturePhotoButtonState extends State<CapturePhotoButton> {
  String? capturedImageBase64;

  @override
  void initState() {
    super.initState();
    if (widget.imageBase64 != null) {
      capturedImageBase64 = widget.imageBase64;
    }
  }

  @override
  void didUpdateWidget(covariant CapturePhotoButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageBase64 != null &&
        widget.imageBase64 != oldWidget.imageBase64) {
      capturedImageBase64 = widget.imageBase64;
    }
  }

  Future<void> onCapturePhoto() async {
    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      final File? imageFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: cameras.first),
        ),
      );

      if (imageFile != null) {
        final List<int> imageBytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(imageBytes);

        setState(() {
          capturedImageBase64 = base64Image;
        });

        widget.onImageCaptured(base64Image);

        if (kDebugMode) {
          print('Image Captured: $base64Image');
        }
      }
    } else {
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
        width: 224,
        height: 126,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0),
          image: capturedImageBase64 != null
              ? DecorationImage(
                  image: MemoryImage(base64Decode(capturedImageBase64!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: capturedImageBase64 == null
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
            : null,
      ),
    );
  }
}




/*
// This code works:
// PATH: lib/screens/add_fountain/widgets/capture_photo_button.dart

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/screens/add_fountain/take_picture_screen.dart';

class CapturePhotoButton extends StatefulWidget {
  final File? imageFile; // Still nullable here
  final Function(String) onImageCaptured;

  const CapturePhotoButton({
    super.key,
    this.imageFile,
    required this.onImageCaptured,
  });

  @override
  _CapturePhotoButtonState createState() => _CapturePhotoButtonState();
}

class _CapturePhotoButtonState extends State<CapturePhotoButton> {
  File? capturedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.imageFile != null) {
      capturedImageFile = widget.imageFile;
    }
  }

  Future<void> onCapturePhoto() async {
    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {
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

        widget.onImageCaptured(capturedImageFile!.path); // Calling the callback

        if (kDebugMode) {
          print('Image File Path: ${capturedImageFile?.path}');
        }
        capturedImageFile?.exists().then((exists) {
          if (kDebugMode) {
            print('File Exists: $exists');
          }
        });
      }
    } else {
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
    }
    return Image.file(capturedImageFile!);
  }
}
*/

/*
// PATH: lib/screens/add_fountain/widgets/capture_photo_button.dart
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/screens/add_fountain/take_picture_screen.dart';

class CapturePhotoButton extends StatefulWidget {
  final File? imageFile; // Still nullable here

  const CapturePhotoButton({Key? key, this.imageFile})
      : super(key: key); // No change needed

  @override
  _CapturePhotoButtonState createState() => _CapturePhotoButtonState();
}

class _CapturePhotoButtonState extends State<CapturePhotoButton> {
  File? capturedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.imageFile != null) {
      capturedImageFile = widget.imageFile;
    }
  }

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
*/