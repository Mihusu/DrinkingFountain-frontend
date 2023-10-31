// lib/main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toerst/models/fountain_location.dart';
import 'package:toerst/models/nearest_fountain.dart';
import 'package:toerst/screens/focus_fountain/focus_fountain_screen.dart';
import 'package:toerst/screens/map/widgets/add_fountain_button.dart';
import 'package:toerst/screens/map/widgets/bottom_app_bar.dart';
import 'package:toerst/services/location_manager.dart';
import 'package:toerst/widgets/google_map.dart';

// Import widgets
// import 'package:toerst/widgets/floating_action_button.dart';
// import 'package:toerst/screens/map/widgets/bottom_app_bar.dart';
// import 'widgets/google_map.dart';
import 'package:toerst/screens/map/widgets/draggable_fountain_list.dart';
//import 'screens/map/widgets/user_location_button.dart';

// Http
import 'package:http/http.dart' as http;
import 'dart:convert';

// env file
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import constants
import 'package:toerst/config/draggable_sheet_constants.dart';

import 'package:toerst/config/sheet_properties.dart';
import 'package:toerst/themes/app_colors.dart';

//Secure storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import services
// import 'package:toerst/services/location_manager.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  double _sheetPosition = initialSheetPosition;
  String _mapStyle = " ";
  late GoogleMapController _mapController;
  late AnimationController _controller;
  late Animation<double> _animation;
  LatLng? _initialCameraPosition;
  final Set<Marker> _markers = Set<Marker>();
  final List<NearestFountain> _nearestFountains = [];
  final secureStorage = new FlutterSecureStorage();

  Map<SheetPositionState, SheetProperties> _sheetPropertiesMap = {};

  @override
  void initState() {
    super.initState();
    _initialize();
    _sheetPropertiesMap = {
      SheetPositionState.top: SheetProperties(
        icon: Icons.arrow_downward,
        text: "Shrink List",
        action: () => snapSheet(middlePosition),
      ),
      SheetPositionState.middle: SheetProperties(
        icon: Icons.map,
        text: "Expand Map",
        action: () => snapSheet(bottomPosition),
      ),
      SheetPositionState.bottom: SheetProperties(
        icon: Icons.list,
        text: "Expand List",
        action: () => snapSheet(middlePosition),
      ),
    };
    _loadMapStyle();
    _initializeAnimationController();
  }

  bool _loading = true; // Set to true initially

  void _initialize() async {
    final locationService = LocationService();
    final initialLocation = await locationService.fetchInitialLocation();
    if (initialLocation != null) {
      setState(() {
        _initialCameraPosition = initialLocation;
        setState(() {
          _loading = false;
        });
        createMarkers(initialLocation);
        createNearestFountains(initialLocation);
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  // Function to generate random markers
  Future<void> createMarkers(position) async {
    final apiKey = dotenv.env['API_KEY'] ?? 'default';
    final ip = dotenv.env['BACKEND_IP'] ?? 'default';
    final headers = <String, String>{'Api-Key': apiKey};
    final double latitude = position.latitude;
    final double longitude = position.longitude;
    final url =
        'http://$ip/fountain/map?longitude=$longitude&latitude=$latitude';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      for (var json in jsonList) {
        final FountainLocation location = FountainLocation.fromJson(json);

        _markers.add(
          Marker(
            markerId: MarkerId(
                'marker${location.id}'), // Use a unique ID for each marker
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FocusFountainScreen(
                      secureStorage: secureStorage,
                      fountainId: location.id,
                    ),
                  ),
                )
              },
              title: 'Fountain ${location.id}',
              snippet: 'Distance ${location.distance.toStringAsFixed(2)} km',
            ),
          ),
        );
      }
      setState(() {
        _loading = false;
      });
    } else {
      if (kDebugMode) {
        print("Api failed");
      }
    }
  }

  Future<void> createNearestFountains(position) async {
    final apiKey = dotenv.env['API_KEY'] ?? 'default';
    final ip = dotenv.env['BACKEND_IP'] ?? 'default';
    final headers = <String, String>{'Api-Key': apiKey};
    final double latitude = position.latitude;
    final double longitude = position.longitude;
    final url =
        'http://$ip/fountain/nearest/list?longitude=$longitude&latitude=$latitude';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      final nearestFountains =
          jsonList.map((json) => NearestFountain.fromJson(json)).toList();

      setState(() {
        _nearestFountains.addAll(nearestFountains);
        _loading = false;
      });
    } else {
      if (kDebugMode) {
        print("Api failed");
      }
    }
  }

  SheetPositionState _getCurrentState() {
    if (_sheetPosition <= 0.1) {
      return SheetPositionState.top;
    } else if (_sheetPosition <= middlePosition) {
      return SheetPositionState.middle;
    } else {
      return SheetPositionState.bottom;
    }
  }

  void _loadMapStyle() {
    rootBundle.loadString('assets/themes/silverMapTheme.json').then((string) {
      setState(() {
        _mapStyle = string;
      });
    });
  }

  void _initializeAnimationController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration.toInt()),
    );
  }

  void snapSheet(double targetPosition) {
    _animation = Tween<double>(begin: _sheetPosition, end: targetPosition)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _sheetPosition = _animation.value;
        });
      });

    _controller.reset();
    _controller.forward();
  }

  double getSnapPosition(double currentPosition) {
    double distTop = (currentPosition - topReference).abs();
    double distMiddle = (currentPosition - middleReference).abs();
    double distBottom = (currentPosition - bottomReference).abs();

    if (distTop <= distMiddle && distTop <= distBottom) {
      return topPosition;
    } else if (distMiddle <= distTop && distMiddle <= distBottom) {
      return middlePosition;
    } else {
      return bottomPosition;
    }
  }

   Future<void> _goToCurrentLocation() async {
    final location = Location();
    final hasPermission = await location.hasPermission();

    if (hasPermission == PermissionStatus.denied) {
      await location.requestPermission();
    }

    final currentLocation = await location.getLocation();

    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      final target =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      // Combine position and zoom into a single CameraPosition
      final cameraPosition = CameraPosition(
        target: target,
        zoom: 16.0,
      );

      // Update the camera position in one go
      await _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } else {
      if (kDebugMode) {
        print("Latitude and Longitude are null");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: CustomBottomAppBar(
          // Set the properties for the left button on the buttom app bar:
          icon: _sheetPropertiesMap[_getCurrentState()]!.icon,
          text: _sheetPropertiesMap[_getCurrentState()]!.text,
          action: _sheetPropertiesMap[_getCurrentState()]!.action,
          secureStorage: secureStorage),
      floatingActionButton: const AddFountainButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          GoogleMapWidget(
            loading: _loading,
            mapStyle: _mapStyle,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              controller.setMapStyle(_mapStyle);
            },
            markers: _markers,
          ),
          _buildFloatingActionButton(screenHeight),
          DraggableFountainList(
            sheetPosition: _sheetPosition,
            onVerticalDragUpdate: (delta) {
              setState(() {
                _sheetPosition += delta;
              });
            },
            onVerticalDragEnd: (details) {
              snapSheet(getSnapPosition(_sheetPosition));
            },
            listedItemColor: listedItemColor,
            listedItemBorderColor: listedItemBorderColor,
            listedItemTextColor: listedItemTextColor,
            loading: _loading,
            nearestFountains: _nearestFountains,
          ),
        ],
      ),
    );
  }

  Positioned _buildFloatingActionButton(double screenHeight) {
    return Positioned(
      top: (_sheetPosition * screenHeight) - 70,
      right: 14,
      child: _sheetPosition != 0.1
          ? FloatingActionButton(
              heroTag: "newFountain",
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.black,
              child: const Icon(Icons.my_location),
            )
          : Container(),
    );
  }
}
