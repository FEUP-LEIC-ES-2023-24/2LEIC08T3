import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:greenscan/Services/auth.dart';
import 'package:greenscan/Services/dbUser.dart';
import 'package:greenscan/Services/store.dart';
import 'package:image_picker/image_picker.dart';
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

  static Future<String> uploadImage(XFile image) async {
    String filePath =
        'products/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);

    firebase_storage.UploadTask uploadTask = ref.putFile(File(image.path));
    try {
      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Upload failed: $e");
      return ''; // Return an empty string if the upload fails
    }
  }

  static Future<void> firebaseAddProduct(
      String id, Product product, XFile? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile); // Upload the image first
    }

    final docToAdd = {
      "brand": product.brand,
      "category": product.category,
      "country": product.country,
      "imageUrl": imageUrl, // Use the uploaded image URL
      "labels": product.labels,
      "materials": product.materials,
      "name": product.name,
      "search": product.search,
      "stores": product.stores,
      "sustainableScore": product.sustainableScore,
      "transportScore": product.transportScore,
      "materialScore": product.materialScore,
      "labelScore": product.labelScore
    };

    await db.collection("items").doc(id).set(docToAdd).catchError((e) {
      print("Error adding document: $e");
    });
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

    // add the scan to the history
    if (AuthService.user == null) {
      print("user is null");
    } else {
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(AuthService.user!.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        print("couldn't find the user!");
      } else {
        final data = doc.data() as Map<String, dynamic>;
        final historyData;

        if (data.containsKey('history')) {
          historyData = data['history'] as List<dynamic>;

          if (!historyData.contains(id)) {
            historyData.add(id);

            await docRef.update({
              'history': historyData,
            });
          }
        } else {
          historyData = [id];

          await docRef.update({
            'history': historyData,
          });
        }
      }
    }

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

  static Future<Map<String, String>> firebaseGetSearchProduct() async {
    final productsRef = db.collection("items");
    Map<String, String> productMap = {};

    await productsRef.get().then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String productName = data["name"];
          String productCode = doc.id;
          productMap[productName] = productCode;
        });
      },
      onError: (e) => print("Error getting documents: $e"),
    );

    for (var key in productMap.keys) {
      print("Product: $key, Code: ${productMap[key]}");
    }

    return productMap;
  }
}
