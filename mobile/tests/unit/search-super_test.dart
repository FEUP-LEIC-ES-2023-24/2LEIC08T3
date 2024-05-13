import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenscan/pages/search-super.dart';

void main() {
  testWidgets('SearchPlacesScreen UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: SearchPlacesScreen()));

    // Verify that the AppBar has 'Supermarket Search' as title
    expect(find.widgetWithText(AppBar, 'Supermarket Search'), findsOneWidget);

    // Verify that the GoogleMap widget is present
    expect(find.byType(GoogleMap), findsOneWidget);
  });
}