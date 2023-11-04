import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:toerst/models/viewed_fountain.dart';
import 'package:toerst/screens/view_fountain/widgets/review_card.dart';
import 'package:toerst/services/location_service.dart';
import 'package:toerst/services/network_service.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/custom_circular_button.dart';
import 'package:toerst/widgets/standard_button.dart';

class FocusFountainScreen extends StatefulWidget {
  final int fountainId;

  const FocusFountainScreen({required this.fountainId, Key? key})
      : super(key: key);

  @override
  _FocusFountainScreenState createState() => _FocusFountainScreenState();
}

class _FocusFountainScreenState extends State<FocusFountainScreen> {
  bool _loading = true;
  CurrentFountain? _fountainData;
  LocationService _locationService = LocationService();
  String? _address;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final networkService = NetworkService();
    final data = await networkService.getCurrentFountainData(widget.fountainId);

    setState(() {
      _fountainData = data; // Update the state when data is available
    });

    if (_fountainData != null) {
      _address = await _locationService.fetchAddress(
        _fountainData!.latitude,
        _fountainData!.longitude,
      );

      setState(() {
        _address = _address ?? "Location not found"; // Handle null address
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (!_loading) {
      // Decode the Base64 string to bytes
      Uint8List bytes = base64.decode(_fountainData!.fountainImages[0].base64);

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
          alignment: Alignment.topCenter, // Adjust the alignment as needed
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: <Widget>[
              SizedBox(height: screenHeight * 0.025),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
                child: Image.memory(
                  bytes,
                  width: screenWidth *0.8, // Adjust the width and height as needed
                  height: screenHeight * 0.3,
                  fit: BoxFit
                      .cover, // Use BoxFit to specify how the image should be fitted within the container
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Text(
                _address ?? "Location not found",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the Row horizontally
                children: List.generate(
                  _fountainData!.score.toInt(),
                  (index) => const Icon(Icons.star,
                      size: 30.0, color: listedItemTextColor),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              StandardButton(
                label: "Rate This Fountain",
                onPressed: () => print(_fountainData!.reviews[0].username),
                borderColor: Colors.black,
              ),
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.only(top: 13.0, bottom: 70.0),
                itemCount: _fountainData!.reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReviewCard(review: _fountainData!.reviews[index]);
                },
              )),
            ],
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
