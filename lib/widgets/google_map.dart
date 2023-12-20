import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toerst/themes/app_colors.dart';

class GoogleMapWidget extends StatelessWidget {
  final bool loading;
  final String mapStyle;
  final LatLng? initialCameraPosition;
  final Function(GoogleMapController) onMapCreated;
  final Set<Marker> markers;

  const GoogleMapWidget({
    super.key,
    required this.loading,
    required this.mapStyle,
    this.initialCameraPosition,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: loadingIndicatorColor,
        ),
      ); // Show a loading spinner while we're fetching the location
    }
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialCameraPosition ?? const LatLng(55.6761, 12.5683),
        zoom: 16,
      ),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      // compassEnabled: false,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      markers: markers,
    );
  }
}
