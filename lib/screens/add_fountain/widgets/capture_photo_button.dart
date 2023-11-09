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
    super.key,
    this.imageBase64,
    required this.onImageCaptured,
  });

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
        const SnackBar(content: Text('No cameras available')),
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
