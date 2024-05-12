import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/add_product.dart';

void main() {
  testWidgets('AddProductPage Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: AddProductPage(),
    ));

    // Verify that the AddProductPage widget is present.
    expect(find.byType(AddProductPage), findsOneWidget);
  });
}