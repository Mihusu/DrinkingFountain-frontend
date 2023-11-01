import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:toerst/screens/add_fountain/display_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max, // Changed to max for higher resolution
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File> cropImage(File originalImage, double aspectRatio) async {
    final original = img.decodeImage(await originalImage.readAsBytes())!;

    // Calculate the desired height based on the aspect ratio
    final height = original.width / aspectRatio;

    // Calculate the y offset to center the cropped portion vertically
    final yOffset = (original.height - height) ~/ 2;

    final cropped = img.copyCrop(original,
        x: 0, y: yOffset, width: original.width, height: height.toInt());

    final croppedFile =
        await originalImage.writeAsBytes(img.encodeJpg(cropped));
    return croppedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        centerTitle: true,
        title: const Text('Take a picture of the fountain'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Obtain the aspect ratio from the CameraController
              final aspectRatio = _controller.value
                  .aspectRatio; // Changed to get aspect ratio from controller
              return AspectRatio(
                aspectRatio: aspectRatio,
                child: CameraPreview(_controller),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 60.0),
        child: SizedBox(
          height: 80,
          width: 80,
          child: FloatingActionButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();
                if (!mounted) return;

                // Apply the cropping after capturing the image
                final croppedFile = await cropImage(
                    File(image.path),
                    _controller.value
                        .aspectRatio); // Changed to get aspect ratio from controller

                final returnedFile = await Navigator.of(context).push<File>(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      imagePath: croppedFile.path,
                      camera: widget.camera,
                    ),
                  ),
                );

                if (returnedFile != null) {
                  Navigator.pop(context, returnedFile);
                }
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            },
            backgroundColor: Colors.yellow,
            child: const IconTheme(
              data: IconThemeData(size: 40),
              child: Icon(Icons.camera_alt),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
