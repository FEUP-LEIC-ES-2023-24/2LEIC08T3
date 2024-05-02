import 'package:flutter/material.dart';
import 'package:greenscan/pages/add_product.dart';
import 'package:greenscan/pages/barcode.dart';
import 'package:greenscan/pages/login.dart';
import 'package:greenscan/pages/map.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
                  children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff4b986c),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.scanner),
              title: const Text('Scan'),
              onTap: () async {
                String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666', // Cor da barra de cima da tela
                  'Cancelar', // Texto do botão de cancelar
                  true, // Mostrar alerta de flash
                  ScanMode.BARCODE, // Modo de escaneamento (código de barras)
                );
                if (barcodeResult != '-1') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarcodeReaderPage()),
                  );
                }  
              },
            ),
            if (true) // TODO: Add conditional for add user 
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Add Product'),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddProductPage()),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Whislist'),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.compare),
              title: const Text('Compare'),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {

              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
            );
              },
            ),
          ],
      )
    );
  }
}