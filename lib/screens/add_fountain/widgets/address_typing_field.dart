import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class AddressSearchWidget extends StatelessWidget {
  final Function(String, double, double) onLocationSelected;
  late final GoogleMapsPlaces _places;

  AddressSearchWidget({required this.onLocationSelected}) {
    final apiKey = dotenv.dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null) {
      throw Exception('Google Maps API key not found');
    }
    _places = GoogleMapsPlaces(apiKey: apiKey!);
  }

  Future<void> _handlePress(BuildContext context) async {
    final apiKey = dotenv.dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null) {
      throw Exception('Google Maps API key not found');
    }
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey!,
      mode: Mode.overlay,
      language: "da",
      components: [Component(Component.country, "dk")],
    );
    if (prediction != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(prediction.placeId ?? '');
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;
      final description = detail.result.formattedAddress; // Get the human-readable address
      if (lat != null && lng != null) {
        onLocationSelected(description!, lat, lng); // Pass both the address and coordinates
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handlePress(context),
      child: Text("Search Address"),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class AddressSearchWidget extends StatelessWidget {
  late final GoogleMapsPlaces _places;

  AddressSearchWidget() {
    final apiKey = dotenv.dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null) {
      throw Exception('Google Maps API key not found');
    }
    _places = GoogleMapsPlaces(apiKey: apiKey);
  }

  Future<void> _handlePress(BuildContext context) async {
    final apiKey = dotenv.dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null) {
      throw Exception('Google Maps API key not found');
    }
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      mode: Mode.overlay,
      language: "da",
      components: [Component(Component.country, "dk")],
    );
    if (prediction != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(prediction.placeId ?? '');
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;
      if (lat != null && lng != null) {
        print(
            "Selected place: ${prediction.description}, Latitude: $lat, Longitude: $lng");
      } else {
        print(
            "Failed to retrieve location details for: ${prediction.description}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handlePress(context),
      child: Text("Search Address"),
    );
  }
}
*/