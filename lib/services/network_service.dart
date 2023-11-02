// PATH: lib/services/network_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toerst/models/fountain_location.dart';
import 'package:toerst/models/nearest_fountain.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NetworkService {
  final String apiKey = dotenv.env['API_KEY'] ?? 'default';
  final String ip = dotenv.env['BACKEND_IP'] ?? 'default';

  Future<Set<Marker>> createMarkers(LatLng position) async {
    final headers = <String, String>{'Api-Key': apiKey};
    final double latitude = position.latitude;
    final double longitude = position.longitude;
    final url =
        'http://$ip/fountain/map?longitude=$longitude&latitude=$latitude';

    final response = await http.get(Uri.parse(url), headers: headers);
    final Set<Marker> markers = {};

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      for (var json in jsonList) {
        final FountainLocation location = FountainLocation.fromJson(json);
        markers.add(
          Marker(
            markerId: MarkerId('marker${location.id}'),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
              title: 'Fountain ${location.id}',
              snippet: 'Distance ${location.distance.toStringAsFixed(2)} km',
            ),
          ),
        );
      }
    } else if (kDebugMode) {
      print("Api failed");
    }

    return markers;
  }

  Future<List<NearestFountain>> createNearestFountains(LatLng position) async {
    final headers = <String, String>{'Api-Key': apiKey};
    final double latitude = position.latitude;
    final double longitude = position.longitude;
    final url =
        'http://$ip/fountain/nearest/list?longitude=$longitude&latitude=$latitude';

    final response = await http.get(Uri.parse(url), headers: headers);
    final List<NearestFountain> nearestFountains = [];

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      nearestFountains.addAll(
        jsonList.map((json) => NearestFountain.fromJson(json)).toList(),
      );
    } else if (kDebugMode) {
      print("Api failed");
    }

    return nearestFountains;
  }
}
