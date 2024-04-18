import 'dart:convert';
import 'package:flutter/services.dart';

class ScoreCalculation {
  static Map<String, dynamic> _materialScores = {};

  static Future<void> loadMaterialScores() async {
    final jsonString = await rootBundle.loadString('assets/materials.json');
    _materialScores = json.decode(jsonString);
  }


  static double computeTransportScore(double distance) {
    if (distance > 500) {
      double score = 90 - ((distance - 500) / 500 * 20);
      return score > 0 ? score : 0;
    }
    return 100;
  }

  static int getMaterialRecyclability(String material) {
    return _materialScores[material]?['recyclability'] ?? 0;
  }
}