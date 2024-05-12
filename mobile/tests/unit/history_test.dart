import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:greenscan/pages/history.dart';

class MockUser extends Mock implements User {
  @override
  String get uid => '123';
}

void main() {
  testWidgets('HistoryPage widget test', (WidgetTester tester) async {
    // Create a mock user
    User mockUser = MockUser();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HistoryPage(user: mockUser)));

    // Verify that the HistoryPage creates a FutureBuilder.
    expect(find.byType(FutureBuilder), findsOneWidget);

    // Verify that the HistoryPage creates a Scaffold.
    expect(find.byType(Scaffold), findsOneWidget);
  });
}