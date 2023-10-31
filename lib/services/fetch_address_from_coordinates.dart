import 'package:geocoding/geocoding.dart';

Future<String?> fetchAddressFromCoordinates(
    double latitude, double longitude) async {
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
      print('No address found for the provided coordinates.');
      return null;
    }
  } catch (e) {
    // Log any errors that occur during the fetch
    print('Error occurred: $e');
    return null;
  }
}
