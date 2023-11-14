// PATH: lib/services/maps_launcher_service.dart

import 'package:maps_launcher/maps_launcher.dart'; // Import map_launcher

void getDirectionsFromAddress(String address) {
  MapsLauncher.launchQuery(address);
}

void getDirectionsFromCoordinates(double latitude, double longitude) {
  MapsLauncher.launchCoordinates(latitude, longitude);
}
