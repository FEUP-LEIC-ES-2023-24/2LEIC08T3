import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/login.dart';

void main() {
  testWidgets('Login page test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(emailField, 'a@a.com');
    await tester.enterText(passwordField, '123456');
    await tester.tap(loginButton);

    await tester.pumpAndSettle();
  });
}