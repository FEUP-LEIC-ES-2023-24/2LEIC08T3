import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/login.dart';

void main() {
  testWidgets('LoginPage has two TextField widgets', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Verify that LoginPage has two TextField widgets.
    expect(find.byType(TextField), findsNWidgets(2));
  });
}