import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/Services/product.dart';

class Store {
  final String name;
  final GeoPoint location;

  Store({required this.name, required this.location});

  static Future<Store?> buildStoreDB(Map<String, dynamic>? data) async {
    if (data == null) return null;

    if (!(data.containsKey("name") || data.containsKey("location"))) {
      return null;
    }

    return Store(name: data["name"], location: data["location"]);
  }

}