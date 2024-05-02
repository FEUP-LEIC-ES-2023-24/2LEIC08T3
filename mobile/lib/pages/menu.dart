import 'package:flutter/material.dart';
import 'package:greenscan/Services/auth.dart';
import 'package:greenscan/pages/add_product.dart';
import 'package:greenscan/pages/barcode.dart';
import 'package:greenscan/pages/history.dart';
import 'package:greenscan/pages/login.dart';
import 'package:greenscan/pages/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SideBar extends StatelessWidget {
  User user;
  SideBar({required this.user});

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
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryPage(user: user)),
                  );
              },
            ),
            if (AuthService.dbUser!.admin)
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