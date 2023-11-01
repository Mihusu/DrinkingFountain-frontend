// PATH: lib/services/location_service.dart
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  final Location _location = Location();

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
}
