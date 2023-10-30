import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // for debug purposes
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; // <-- Added this import
import 'package:toerst/screens/add_fountain/display_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

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
      ResolutionPreset.medium,
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

    // Correctly use the named arguments for the copyCrop function
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
              return AspectRatio(
                aspectRatio: 16 / 9,
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
                final croppedFile = await cropImage(File(image.path), 16 / 9);

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
              data: IconThemeData(size: 40), // Adjust the icon size
              child: Icon(Icons.camera_alt),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


/*
// PATH: lib/screens/add_fountain/take_picture_screen.dart

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // for debug purposes
import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/display_picture_screen.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera; // Make sure this line is present

  const TakePictureScreen({
    Key? key,
    required this.camera, // And this line as well
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (!mounted) return;
            final returnedFile = await Navigator.of(context).push<File>(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  camera: widget.camera, // <-- Update this line
                ),
              ),
            );
            if (returnedFile != null) {
              Navigator.pop(context,
                  returnedFile); // Return the file to CapturePhotoButton
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },

        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
*/