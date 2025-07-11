import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  String barcode;
  String name;
  String? imageUrl;

  HistoryModel({required this.barcode, required this.name});

  static Future<List<HistoryModel>> getHistory(String userUuid) async {
    List<HistoryModel> history = [];

    final docRef = FirebaseFirestore.instance.collection("users").doc(userUuid);
    final doc = await docRef.get();

    if (!doc.exists) {
      print("couldn't find the doc!");
      return history;
    }

    final data = doc.data() as Map<String, dynamic>;

    if (data.containsKey('history')) {
      final historyData = data['history'] as List<dynamic>;
      history = historyData
          .map((item) => HistoryModel(barcode: item, name: "Missing!"))
          .toList();
    }

    for (var entry in history.asMap().entries) {
      final docRef =
          FirebaseFirestore.instance.collection("items").doc(entry.value.barcode);
      final doc = await docRef.get();

      if (!doc.exists) {
        print("${entry.value.barcode} doens't exist in the database!");
        continue;
      }

      if (doc.data()!.containsKey('name')) {
        history[entry.key].name = doc["name"];
      }

      if (doc.data()!.containsKey('imageUrl')) {
        history[entry.key].imageUrl = doc["imageUrl"];
      }
    }

    history.removeWhere((item) => item.name == "Missing!");

    return history;
  }
}
