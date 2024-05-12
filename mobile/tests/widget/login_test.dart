import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/login.dart';

void main() {
  testWidgets('Login page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Find the TextFields and button.
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.byType(ElevatedButton);

    // Simulate user interactions.
    await tester.enterText(emailField, 'z@z.pt');
    await tester.enterText(passwordField, '123456');
    await tester.tap(loginButton);

    // Trigger a frame.
    await tester.pumpAndSettle();

    // Check that the AuthService.signInEmail method is called with correct parameters.
    // Note: You'll need to mock the AuthService to test this.
    // This is just a placeholder, replace with your actual test.
    // expect(AuthService.signInEmail, calledOnceWith('test@example.com', 'password123'));
  });
}