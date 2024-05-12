import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenscan/pages/google-maps.dart'; // replace with your actual package name

void main() {
  testWidgets('GoogleMapsPage widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: GoogleMapsPage(storePosition: LatLng(41.1780, -8.5980)),
    ));

    // Verify that GoogleMapsPage widget is displayed.
    expect(find.byType(GoogleMapsPage), findsOneWidget);
  });
}