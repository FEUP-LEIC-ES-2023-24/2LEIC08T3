import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class FakeUser extends Fake implements User {
  @override
  String get uid => '123';
}

void main() {
  testWidgets('HistoryPage shows CircularProgressIndicator while loading', (WidgetTester tester) async {
    // Use the fake user
    FakeUser fakeUser = FakeUser();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: HistoryPage(user: fakeUser),
    ));

    // Verify that a CircularProgressIndicator is shown while loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}