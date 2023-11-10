// PATH: lib/screens/add_fountain/widgets/address_input_widget.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:toerst/screens/add_fountain/widgets/submit_address_button.dart';
import 'package:toerst/services/fetch_address_from_coordinates.dart';
import 'package:toerst/services/location_service.dart';

const double locationPadding = 16.0;

class AddressInputWidget extends StatefulWidget {
  AddressInputWidget({Key? key, required this.onAddressSelected}) : super(key: key);

  final Function(String, double, double) onAddressSelected;
  
  @override
  _AddressInputWidget createState() => _AddressInputWidget();
}

class _AddressInputWidget extends State<AddressInputWidget> {
  String _currentAddress = "";

  Future<void> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        widget.onAddressSelected(address, location.latitude, location.longitude);
        final foundAddress = await _findAddress(location.latitude, location.longitude);
        setState(() {
          _currentAddress = foundAddress; 
        });
      }
    } catch (e) {
      setState(() {
         _currentAddress = "Not Found"; 
      });
      print('Error occurred: $e');
    }
  }

   // Fetch the address based on the latitude and longitude
  Future<String> _findAddress(latitude, longitude) async {
    String? address = await fetchAddressFromCoordinates(latitude, longitude);
    if (address != null) {
      return address;
    }
    return "No address found";
  }

  @override
  Widget build(BuildContext context) {
    final addressController =
        TextEditingController(); // Define the controller outside the onPressed

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.7, // 70% of screen width
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Enter Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                suffixIcon: 
                Padding(
                  padding: EdgeInsets.only(right: 8.0), // Adjust the padding value as needed
                  child: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.my_location), // You can change this to your desired icon
                    onPressed: () async {
                      final locationService = LocationService();
                      final initialLocation = await locationService.fetchInitialLocation();

                      final address = await _findAddress(initialLocation!.latitude, initialLocation.longitude);
                      setState(() {
                        _currentAddress = address;
                        widget.onAddressSelected(address, initialLocation.latitude, initialLocation.longitude);
                      });
                    },
                  ),
                ),
              ),
              onSubmitted: (address) async {
                await _getCoordinatesFromAddress(address);
              },
            )
          ),
          SizedBox(height: 10),
          Text(_currentAddress),
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
