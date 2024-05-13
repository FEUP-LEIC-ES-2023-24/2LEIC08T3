import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenscan/pages/add_product.dart';

void main() {
  testWidgets('AddProductPage widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: AddProductPage()));

    // Verify that the AddProductPage creates a Form.
    expect(find.byType(Form), findsOneWidget);

    // Verify that the Form creates TextFormFields.
    expect(find.byType(TextFormField), findsWidgets);
  });
}