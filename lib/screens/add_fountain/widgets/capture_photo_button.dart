// PATH: lib/screens/add_fountain/widgets/capture_photo_button.dart

import 'dart:convert';
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

        final List<int> imageBytes = await capturedImageFile!.readAsBytes();
        final String base64Image = base64Encode(imageBytes);
        widget.onImageCaptured(base64Image);

        if (kDebugMode) {
          print('Image File Path: ${capturedImageFile?.path}');
          capturedImageFile?.exists().then((exists) {
            print('File Exists: $exists');
          });
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
          image: capturedImageFile != null
              ? DecorationImage(
                  image: FileImage(capturedImageFile!),
                  fit: BoxFit
                      .cover, // This will ensure the image fits inside the border while maintaining its aspect ratio.
                )
              : null,
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
            : null, // Since the image is now part of the container's decoration, we can return null when an image is present.
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