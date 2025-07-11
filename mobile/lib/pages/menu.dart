import 'package:flutter/material.dart';
import 'package:greenscan/Services/auth.dart';
import 'package:greenscan/pages/add_product.dart';
import 'package:greenscan/pages/history.dart';
import 'package:greenscan/pages/google-maps.dart';
import 'package:greenscan/pages/product-comparator-page.dart';
import 'package:greenscan/pages/search-super.dart';
import 'package:greenscan/pages/login.dart';

class SideBar extends StatelessWidget {
  SideBar();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('History'),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryPage()),
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
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
            },
          ),
        ListTile(
          leading: const Icon(Icons.compare),
          title: const Text('Compare'),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductComparatorPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.map),
          title: const Text('Map'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPlacesScreen()),
            );
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
    ));
  }
}
