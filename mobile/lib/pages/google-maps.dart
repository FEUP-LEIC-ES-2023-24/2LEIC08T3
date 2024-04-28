import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  State<GoogleMapsPage> createState() => GoogleMapsPageState();
}

class GoogleMapsPageState extends State<GoogleMapsPage> {
  static const feup = LatLng(41.1780, -8.5980);
  static const continente = LatLng(41.177536, -8.591184);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: feup,
        zoom: 15,
      ),
      markers: {
        const Marker(
          markerId: MarkerId('FEUP'),
          icon: BitmapDescriptor.defaultMarker,
          position: feup,
        ),
        const Marker(
          markerId: MarkerId('Continente'),
          icon: BitmapDescriptor.defaultMarker,
          position: continente,
        ),
      },
    ),
  );
}