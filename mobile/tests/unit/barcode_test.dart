import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenscan/pages/barcode.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

void main() {
  // Create a mock user
  User mockUser = MockUser();

  testWidgets('BarcodeReaderPage widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: BarcodeReaderPage()));

    // Verify that the BarcodeReaderPage is created.
    expect(find.byType(BarcodeReaderPage), findsOneWidget);
  });
}