import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Map<String, dynamic>? _countryCoordinates;

  static Future<void> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  static Future<(double lat, double long)?> getCurrentLatLong() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return (position.latitude, position.longitude);  // Using record to return two values
    } catch (e) {
      // Return null if there is an exception.
      return null;
    }
  }

  static Future<void> loadCountryCoordinates() async {
    final jsonString = await rootBundle.loadString('assets/countries.json');
    _countryCoordinates = json.decode(jsonString);
  }

  static Future<double?> getDistanceToCountry(String countryCode) async {
    if (_countryCoordinates == null) {
      await loadCountryCoordinates();
    }

    final coordinates = _countryCoordinates?[countryCode];
    if (coordinates == null) return null;

    double lat = coordinates['lat'];
    double long = coordinates['long'];

    try {
      Position currentPosition = await Geolocator.getCurrentPosition();

      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        lat,
        long,
      ) / 1000.0; //km

      return distance;
    } catch (e) {
      print('Failed to get distance due to: $e');
      return null;
    }
  }
}
