import 'dart:convert'; // For decoding base64 image
import 'package:flutter/material.dart';
import 'package:toerst/models/fountain.dart';
import 'package:toerst/services/fetch_address_from_coordinates.dart'; // Utility to fetch address
import 'package:toerst/widgets/standard_button.dart';

// Http
import 'package:http/http.dart' as http;

//env file
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Declare constants for easy adjustments and maintainability
const double imageScaleFactor = 1.35;
const double imagePadding = 22.0;
const double containerInnerPadding = 8.0;
const double cardOuterPadding = 16.0;
const double buttonBottomPadding = 40.0;
const double containerBottomPadding = 16.0;

// StatefulWidget to maintain mutable state
class FormOverview extends StatefulWidget {
  final Fountain
      fountainData; // Data to be displayed, passed from previous screen

  const FormOverview({super.key, required this.fountainData});

  @override
  _FormOverviewState createState() => _FormOverviewState();
}

class _FormOverviewState extends State<FormOverview> {
  String? _address; // Local state variable for address
  final secureStorage = new FlutterSecureStorage();

  // This function takes a base64 encoded string and converts it into an Image widget.
  // If the string is null or decoding fails, it returns null.
  Image? _decodeImage(String? base64String) {
    // Check if the input base64String is null. If it is, return null.
    if (base64String == null) return null;

    try {
      // Attempt to decode the base64 encoded string to a Uint8List,
      // and then create an Image widget from it.
      return Image.memory(base64Decode(base64String));
    } catch (e) {
      // If decoding fails, print an error message and return null.
      print("Failed to decode base64 image: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateAddress(); // Fetch the address when the widget initializes
  }

  // Fetch the address based on the latitude and longitude
  Future<void> _updateAddress() async {
    String? address = await fetchAddressFromCoordinates(
        widget.fountainData.latitude, widget.fountainData.longitude);

    if (address != null) {
      setState(() {
        _address = address; // Update the state variable if address is fetched
      });
    }
  }

  // Utility widget to build star rating based on the rating value
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

// Asynchronous function to send a request to save fountain information to the backend.
  Future<void> saveFountainRequest() async {
    // Retrieve API key and backend IP address from environment variables, or set to 'default' if not found.
    final apiKey = dotenv.env['API_KEY'] ?? 'default';
    final ip = dotenv.env['BACKEND_IP'] ?? 'default';

    // Construct the URL for the API request.
    final url = 'http://$ip/fountain/request';

    // Prepare the data payload with fountain information.
    Map data = {
      'longitude': widget.fountainData.longitude, // Longitude of the fountain
      'latitude': widget.fountainData.latitude, // Latitude of the fountain
      'type': widget.fountainData
          .type, // Type of the fountain (e.g., 'FILLING' or 'DRINKING')
      'score': widget.fountainData.rating, // User rating for the fountain
      'base64Images': widget.fountainData
          .imageBase64Format // Base64 encoded image(s) of the fountain
    };

    // Encode the data payload to a JSON-formatted string.
    var body = json.encode(data);

    // Retrieve the JWT token for authorization from secure storage.
    String? jwt = await secureStorage.read(key: "JWT");

    // Check if JWT token exists. If not, return early (presumably to go to login).
    if (jwt == null) {
      return;
    }

    // Prepare the HTTP headers, including API key, content type, and authorization token.
    final headers = <String, String>{
      'Api-Key': apiKey,
      'Content-Type': 'application/json',
      'Authorization': jwt
    };

    // Make the HTTP POST request to save the fountain information.
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    // Print the HTTP status code for debugging purposes.
    print("Result:");
    print(response.statusCode);

    // Check the response status code to determine the outcome of the request.
    if (response.statusCode == 200) {
      // Fountain request was successfully sent.
    } else {
      // Something went wrong with sending the fountain request.
    }
  }

  // Build method for UI
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
            Navigator.pop(context); // Navigate back
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
                          // Display the image at the top
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
                          Text(widget.fountainData.type),
                          const SizedBox(height: 10),
                          _buildStarRating(
                              (widget.fountainData.rating).toInt()),
                          const SizedBox(height: 10),
                          Text(_address ?? ''),
                          const SizedBox(height: 10),
                          Text(widget.fountainData.review ??
                              'No review provided.'),
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
              onPressed: () async {
                // Connect here to Backend perhaps
                saveFountainRequest();
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
