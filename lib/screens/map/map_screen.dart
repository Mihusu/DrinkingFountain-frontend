// lib/screens/map/map_screen.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toerst/config/draggable_sheet_constants.dart';
import 'package:toerst/config/sheet_properties.dart';
import 'package:toerst/screens/map/widgets/add_fountain_button.dart';
import 'package:toerst/screens/map/widgets/bottom_app_bar.dart';
import 'package:toerst/screens/map/widgets/draggable_fountain_list.dart';
import 'package:toerst/services/location_manager.dart';
import 'package:toerst/themes/app_colors.dart';
import 'package:toerst/widgets/google_map.dart';

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

  // User location
  void _initialize() async {
    final locationService = LocationService();
    final initialLocation = await locationService.fetchInitialLocation();
    if (initialLocation != null) {
      setState(() {
        _initialCameraPosition = initialLocation;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
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

// User location
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
        icon: _sheetPropertiesMap[_getCurrentState()]!.icon,
        text: _sheetPropertiesMap[_getCurrentState()]!.text,
        action: _sheetPropertiesMap[_getCurrentState()]!.action,
      ),
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
          ),
        ],
      ),
    );
  }

  // User location
  Positioned _buildFloatingActionButton(double screenHeight) {
    return Positioned(
      top: (_sheetPosition * screenHeight) - 70,
      right: 14,
      child: _sheetPosition != 0.1
          ? FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.black,
              child: const Icon(Icons.my_location),
            )
          : Container(),
    );
  }
}
