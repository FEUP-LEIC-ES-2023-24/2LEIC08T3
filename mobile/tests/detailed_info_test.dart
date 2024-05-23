import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/product-detail-page.dart';

void main() {
  testWidgets('ProductDetailPage widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProductDetailPage(productCodes: ['111', '555']),
    ));

    expect(find.byType(ProductDetailPage), findsOneWidget);
  });
}