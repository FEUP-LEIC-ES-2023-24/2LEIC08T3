import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenscan/Services/auth.dart';
import 'package:greenscan/Services/dbUser.dart';
import 'package:greenscan/Services/store.dart';
import "product.dart";

class DataBase {
  static final db = FirebaseFirestore.instance;

  static Future<void> firebaseAddUser() async {
    final docToAdd = <String, dynamic>{
      "name": AuthService.dbUser!.name,
      "email": AuthService.dbUser!.email,
      "admin": AuthService.dbUser!.admin
    };

    await db
        .collection("users")
        .doc(AuthService.user!.uid)
        .set(docToAdd)
        .onError((e, _) => print("Error writing document: $e"));
  }

  static Future<void> firebaseGetUser() async {
    final userRef = db.collection("users").doc(AuthService.user!.uid);
    Map<String, dynamic>? data;

    await userRef.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>?;
      },
      onError: (e) => print("Error getting document: $e"),
    );

    AuthService.dbUser = await DbUser.buildUserDB(data);
  }

  static Future<dynamic> firebaseAddProduct(id, Product product) async {
    final docToAdd = <String, dynamic>{
      "brand": product.brand,
      "category": product.category,
      "country": product.country,
      "imageUrl": product.imageUrl,
      "labels": product.labels,
      "materials": product.materials,
      "name": product.name,
      "search": product.search,
      "store": product.stores
    };

    await db
        .collection("items")
        .doc(id)
        .set(docToAdd)
        .onError((e, _) => print("Error writing document: $e"));
  }

  static Future<dynamic> firebaseGetProduct(id) async {
    final itemRef = db.collection("items").doc(id.toString().trim());

    Map<String, dynamic>? data;

    await itemRef.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>?;
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return await Product.buildProductDB(data);
  }

  static Future<dynamic> firebaseGetStore(id) async {
    final storeRef = db.collection("stores").doc(id.toString().trim());

    Map<String, dynamic>? data;

    await storeRef.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>?;
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return await Store.buildStoreDB(data);
  }
}
