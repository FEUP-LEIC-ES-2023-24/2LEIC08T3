
import 'package:cloud_firestore/cloud_firestore.dart';
import "product.dart";

class DataBase {

  static final db = FirebaseFirestore.instance;

  static Future<dynamic> firebaseGetProduct(id) async{

    final itemRef = db.collection("items").doc(id);

    try {
      final DocumentSnapshot item = await itemRef.get();
      final data = item.data() as Map<String, dynamic>;
      return Product.buildProduct(data);
    } catch (e) {
      throw Exception("Error getting document: $e");
    }
  }
}


