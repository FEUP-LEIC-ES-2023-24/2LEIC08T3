import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenscan/pages/barcode.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

void main() {
  testWidgets('BarcodeReaderPage Widget Test', (WidgetTester tester) async {
    // Create a mock user for the test
    MockUser mockUser = MockUser();

    // When the uid and displayName properties are accessed, return a fake value
    when(mockUser.uid).thenReturn('123');
    when(mockUser.displayName).thenReturn('Test User');

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: BarcodeReaderPage(user: mockUser),
    ));

    // Verify that the BarcodeReaderPage widget is present.
    expect(find.byType(BarcodeReaderPage), findsOneWidget);
  });
}