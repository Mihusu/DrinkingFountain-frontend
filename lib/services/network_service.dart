// PATH: lib/services/network_service.dart
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toerst/models/fountain_location.dart';
import 'package:toerst/models/nearest_fountain.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toerst/models/viewed_fountain.dart';
import 'package:toerst/screens/view_fountain/view_fountain_screen.dart';
import 'package:toerst/services/location_service.dart';

class NetworkService {
  final String apiKey = dotenv.env['API_KEY'] ?? 'default';
  final String ip = dotenv.env['BACKEND_IP'] ?? 'default';

  Future<Set<Marker>> createMarkers(
      BuildContext context, LatLng position) async {
    final locationService = LocationService();
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

        String address = await locationService.fetchAddress(
                location.latitude, location.longitude) ??
            "No Address Found";

        markers.add(
          Marker(
            markerId: MarkerId('marker${location.id}'),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
                title: address,
                snippet: 'Distance ${location.distance.toStringAsFixed(2)} km',
                onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FocusFountainScreen(fountainId: location.id),
                        ),
                      )
                    }),
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
    final LocationService locationService = LocationService();
    final url =
        'http://$ip/fountain/nearest/list?longitude=$longitude&latitude=$latitude';

    final response = await http.get(Uri.parse(url), headers: headers);
    final List<NearestFountain> nearestFountains = [];

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      nearestFountains.addAll(
          jsonList.map((json) => NearestFountain.fromJson(json)).toList());
      await Future.forEach(nearestFountains,
          (NearestFountain fountainData) async {
        fountainData.address = await locationService.fetchAddress(
            fountainData.latitude, fountainData.longitude);
      });
    } else if (kDebugMode) {
      print("Api failed");
    }

    return nearestFountains;
  }

  Future<CurrentFountain> getCurrentFountainData(int fountainId) async {
    final headers = <String, String>{'Api-Key': apiKey};
    final url = 'http://$ip/fountain/info/$fountainId';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return CurrentFountain.fromJson(json.decode(response.body));
    } else if (kDebugMode) {
      print("Api failed");
    }
    throw Exception("Failed to retrieve data from the API");
  }

  Future<int> createNewReview(jwt, body) async {
    final headers = <String, String>{
      'Api-Key': apiKey,
      'Authorization': jwt,
      'Content-Type': 'application/json',
    };

    final url = 'http://$ip/review/create';

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.statusCode);
    return response.statusCode;
  }
}
