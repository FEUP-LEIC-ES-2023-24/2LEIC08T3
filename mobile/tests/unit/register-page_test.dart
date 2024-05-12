import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/register-page.dart';

void main() {
  testWidgets('RegisterPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: RegisterPage()));

    // Verify that the AppBar has 'Create an Account' as title
    expect(find.widgetWithText(AppBar, 'Create an Account'), findsOneWidget);

    // Verify that the TextField has 'Full Name' as hint
    expect(find.widgetWithText(TextField, 'Full Name'), findsOneWidget);
  });
}