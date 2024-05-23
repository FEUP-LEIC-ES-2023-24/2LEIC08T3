import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/pages/barcode.dart';

void main() {
  testWidgets('Barcode search manually', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BarcodeReaderPage(), 
    ));

    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, '111');
    await tester.pump();

    expect(find.text('111'), findsOneWidget);

    final searchButton = find.byType(ElevatedButton);
    await tester.tap(searchButton);
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pump();

  });
}