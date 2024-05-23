import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/register-page.dart';

void main() {
  testWidgets('Register page Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterPage()));

    final nameField = find.byType(TextField).at(0);
    final emailField = find.byType(TextField).at(1);
    final passwordField = find.byType(TextField).at(2);
    final passwordConfirmField = find.byType(TextField).at(3);
    final registerButton = find.byType(ElevatedButton);

    await tester.enterText(nameField, 'test');
    await tester.enterText(emailField, 'test1@test1.com');
    await tester.enterText(passwordField, '123456');
    await tester.enterText(passwordConfirmField, '123456');
    await tester.tap(registerButton);

    await tester.pumpAndSettle();
  });
}