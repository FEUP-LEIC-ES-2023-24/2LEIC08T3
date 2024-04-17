import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:greenscan/pages/product-detail-page.dart';

class BarcodeReaderPage extends StatefulWidget {
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

  Future<String> scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Cor da barra de cima da tela
        'Cancelar', // Texto do botão de cancelar
        true, // Mostrar alerta de flash
        ScanMode.BARCODE, // Modo de escaneamento (código de barras)
      );

      if (barcode == '-1') {
        throw Exception('No barcode scanned');
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(productCode: barcode),
        ),
      );

      return barcode;
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _barcodeResult,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scan code'),
            ),
          ],
        ),
      ),
    );
  }
}