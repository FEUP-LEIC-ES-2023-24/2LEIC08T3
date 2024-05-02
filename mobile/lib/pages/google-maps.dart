import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPage extends StatefulWidget {
  final LatLng storePosition;
  GoogleMapsPage({Key? key, required this.storePosition});

  @override
  State<GoogleMapsPage> createState() => GoogleMapsPageState();
}

class GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {}; // Initialize the markers set here
  static const feup = LatLng(41.1780, -8.5980);

  @override
  Widget build(BuildContext context) {
    markers.clear(); // Clear the markers set
    markers.add(
      Marker(
        markerId: MarkerId('store'),
        position: widget.storePosition,
      ),
    );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.storePosition, // Change the target to the store's position
          zoom: 15,
        ),
        markers: markers, // Pass the markers set to the GoogleMap widget
      ),
    );
  }
}