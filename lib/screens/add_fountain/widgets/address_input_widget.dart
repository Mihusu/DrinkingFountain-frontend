import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/standard_button.dart'; // Importing the StandardButton

class AddressInputWidget extends StatelessWidget {
  final Function(String, double, double) onAddressSelected;

  const AddressInputWidget({Key? key, required this.onAddressSelected})
      : super(key: key);

  Future<void> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        onAddressSelected(address, location.latitude, location.longitude);
      } else {
        print('No coordinates found for the address.');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressController =
        TextEditingController(); // Define the controller outside the onPressed

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width:
                MediaQuery.of(context).size.width * 0.7, // 70% of screen width
            child: TextField(
              controller:
                  addressController, // Assign the controller to the TextField
              decoration: InputDecoration(
                labelText: 'Enter Address',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(50), // Completely rounded corners
                ),
              ),
              onSubmitted: (address) async {
                await _getCoordinatesFromAddress(address);
              },
            ),
          ),
          SizedBox(height: 10), // Spacer for better UI
          SubmitAddressButton(
            onPressed: () async {
              await _getCoordinatesFromAddress(
                  addressController.text); // Use the controller's text here
            },
          ),
        ],
      ),
    );
  }
}

class SubmitAddressButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitAddressButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardButton(
      borderColor: secondaryButtonBorderColor,
      backgroundColor: secondaryButtonColor,
      textColor: secondaryButtonTextColor,
      label: 'Submit Address',
      onPressed: onPressed,
      // Add other properties of the StandardButton as required
    );
  }
}
