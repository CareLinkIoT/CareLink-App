import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GpsMapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const GpsMapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng gpsPosition = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(title: Text("📍 현재 GPS 위치")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: gpsPosition,
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId("gps"),
            position: gpsPosition,
            infoWindow: InfoWindow(title: "센서 위치"),
          ),
        },
      ),
    );
  }
}
