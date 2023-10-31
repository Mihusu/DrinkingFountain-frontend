import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toerst/models/fountain.dart';
import 'package:toerst/services/fetch_address_from_coordinates.dart'; // Import fetch_address_from_coordinates
import 'package:toerst/widgets/standard_button.dart';

// Declare constants for easy adjustments
const double imageScaleFactor = 1.35;
const double imagePadding = 22.0;
const double containerInnerPadding = 8.0;
const double cardOuterPadding = 16.0;
const double buttonBottomPadding = 40.0;
const double containerBottomPadding = 16.0;

class FormOverview extends StatefulWidget {
  final Fountain fountainData;

  const FormOverview({super.key, required this.fountainData});

  @override
  _FormOverviewState createState() => _FormOverviewState();
}

class _FormOverviewState extends State<FormOverview> {
  String? _address;

  Image? _decodeImage(String? base64String) {
    if (base64String == null) return null;
    try {
      return Image.memory(base64Decode(base64String));
    } catch (e) {
      print("Failed to decode base64 image: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateAddress(); // <-- Replaced _fetchAddressFromCoordinates with _updateAddress
  }

  // <-- Added this function to update the address using the utility function
  Future<void> _updateAddress() async {
    String? address = await fetchAddressFromCoordinates(
        widget.fountainData.latitude, widget.fountainData.longitude);

    if (address != null) {
      setState(() {
        _address = address;
      });
    }
  }

  Widget _buildStarRating(int rating) {
    return Row(
      children: List.generate(
        rating,
        (index) => const Icon(
          Icons.star,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Review Your Entry',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(cardOuterPadding),
                    child: Padding(
                      padding: const EdgeInsets.all(containerInnerPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(imagePadding),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Transform.scale(
                                scale: imageScaleFactor,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: _decodeImage(widget
                                          .fountainData.imageBase64Format) ??
                                      Container(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('${widget.fountainData.type}'),
                          const SizedBox(height: 10),
                          _buildStarRating(
                              (widget.fountainData.rating ?? 0).toInt()),
                          const SizedBox(height: 10),
                          Text('${_address ?? 'Could not fetch address.'}'),
                          const SizedBox(height: 10),
                          Text(
                              '${widget.fountainData.review ?? 'No review provided.'}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: buttonBottomPadding),
            child: StandardButton(
              label: 'Submit',
              onPressed: () {
                // Submit data to the backend
              },
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
          const SizedBox(
              height: containerBottomPadding), // Add some space at the bottom
        ],
      ),
    );
  }
}
