import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toerst/models/fountain.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package

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
    _fetchAddressFromCoordinates();
  }

  Future<void> _fetchAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.fountainData.latitude!, widget.fountainData.longitude!);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final street = placemark.street;
        final city = placemark.locality;
        final state = placemark.administrativeArea;
        final postalCode = placemark.postalCode;

        setState(() {
          _address = "$street, $city, $state $postalCode";
        });
      } else {
        print('No address found for the provided coordinates.');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Review Your Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_decodeImage(widget.fountainData.imageBase64Format) != null)
              _decodeImage(widget.fountainData.imageBase64Format)!,
            const SizedBox(height: 20),
            Text('Type: ${widget.fountainData.type}'),
            const SizedBox(height: 10),
            Text('Rating: ${widget.fountainData.rating}'),
            const SizedBox(height: 10),
            Text('Address: ${_address ?? 'Could not fetch address.'}'),
            const SizedBox(height: 10),
            Text(
                'Review: ${widget.fountainData.review ?? 'No review provided.'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Submit data to the backend
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
