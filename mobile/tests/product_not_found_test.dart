import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/product_not_found.dart';

void main() {
  testWidgets('ProductNotFoundPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProductNotFoundPage()));

    expect(find.text("We couldn't find the product you're looking for."), findsOneWidget);
    expect(find.text("Please check the code and try again."), findsOneWidget);
    expect(find.byIcon(Icons.search_off), findsOneWidget);
  });
}