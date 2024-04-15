import 'package:flutter/material.dart';
import 'login_page.dart';
import 'selection_page.dart';
import 'map_page.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MyApp());
const MaterialColor myCustomColor = MaterialColor(
  0xff4b986c, // Your primary color's hex code as the primary value (index 500)
  <int, Color>{
    50: Color(0xffE0E9DF),
    100: Color(0xffCCE0CC),
    200: Color(0xffB8D7B9),
    300: Color(0xffA4CEA6),
    400: Color(0xff90C59D),
    500: Color(0xff7CB28A),
    600: Color(0xff689977),
    700: Color(0xff548F64),
    800: Color(0xff408651),
    900: Color(0xff21643E),
  },
);
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Example',
      theme: ThemeData(
        primarySwatch: myCustomColor,
      ),
      home: LoginPage(),
    );
  }
}




