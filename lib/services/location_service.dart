// PATH: lib/services/location_service.dart

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding here
import 'package:location/location.dart'
    as loc; // Use alias 'loc' for location package
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  final loc.Location _location = loc.Location(); // Use alias 'loc' here

  /// This method fetches the initial location of the user.
  /// It first checks for permission to access location,
  /// requests permission if not already granted,
  /// and then fetches the current location.
  /// If the location is successfully retrieved, it returns a LatLng object,
  /// otherwise, it returns null.
  Future<LatLng?> fetchInitialLocation() async {
    final hasPermission = await _location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await _location.requestPermission();
    }

    final currentLocation = await _location.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      return LatLng(currentLocation.latitude!, currentLocation.longitude!);
    } else {
      if (kDebugMode) {
        print("Latitude and Longitude are null");
      }
      return null;
    }
  }

  /// This method fetches the address corresponding to the provided latitude and longitude.
  /// It uses the geocoding package to obtain a list of Placemarks for the coordinates,
  /// extracts the first Placemark (if available),
  /// and constructs a formatted address string from its properties.
  /// If the address is successfully retrieved, it returns the address string,
  /// otherwise, it returns null.
  Future<String?> fetchAddress(double latitude, double longitude) async {
    try {
      // Fetch placemarks (locations) based on latitude and longitude
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      // Check if placemarks are available
      if (placemarks.isNotEmpty) {
        // Take the first placemark from the list
        final placemark = placemarks.first;

        // Extract various components of the address
        final street = placemark.street;
        final city = placemark.locality;
        final state = placemark.administrativeArea;
        final postalCode = placemark.postalCode;

        // Form the complete address
        return "$street, $city, $state $postalCode";
      } else {
        // Log a message if no address is found
        if (kDebugMode) {
          print('No address found for the provided coordinates.');
        }
        return null;
      }
    } catch (e) {
      // Log any errors that occur during the fetch
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return null;
    }
  }

  Future<LatLng?> getCurrentLocation() async {
    final location = loc.Location(); // Use the 'loc' alias here
    final hasPermission = await location.hasPermission();

    if (hasPermission == PermissionStatus.denied) {
      await location.requestPermission();
    }

    final currentLocation = await location.getLocation();

    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      return LatLng(currentLocation.latitude!, currentLocation.longitude!);
    } else {
      return null;
    }
  }
}
