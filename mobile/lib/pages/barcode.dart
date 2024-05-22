import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeReaderPage extends StatefulWidget {
  BarcodeReaderPage();
  @override
  _BarcodeReaderPageState createState() => _BarcodeReaderPageState();
}

class _BarcodeReaderPageState extends State<BarcodeReaderPage> {
  String _barcodeResult = 'No barcode scanned';

  @override
  void initState() {
    super.initState();
    scanBarcode();
  }

  Future<void> scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color of the top bar
        'Cancel', // Text of the cancel button
        true, // Show flash alert
        ScanMode.BARCODE, // Scanning mode (barcode)
      );

      if (barcode != '-1') {
        Navigator.pop(context, barcode); // Return the scanned barcode
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  void getFromDatabase() {
    if (_barcodeResult.isNotEmpty && _barcodeResult != 'No barcode scanned') {
      Navigator.pop(context, _barcodeResult);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid barcode')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _barcodeResult,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: const Text('Scan code'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _barcodeResult = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter barcode',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getFromDatabase,
              child: const Text('Get from Database'),
            ),
          ],
        ),
      ),
    );
  }
}