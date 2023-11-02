// PATH: lib/screens/add_fountain/widgets/address_input_widget.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:toerst/screens/add_fountain/widgets/submit_address_button.dart';

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
          const SizedBox(height: 40.0), // Spacer for better UI
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
