import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ScoreCalculation {
  static Map<String, dynamic> _materialScores = {};
  static Map<String, dynamic> _labelDescriptions = {};

  static Future<void> loadJson() async {
    final materialString = await rootBundle.loadString('assets/materials.json');
    _materialScores = json.decode(materialString);

    final labelString = await rootBundle.loadString('assets/labels.json');
    _labelDescriptions = json.decode(labelString);
  }

  static double getTransportScore(double distance) {
    if (distance > 500) {
      double score = 90 - ((distance - 500) / 500 * 20);
      return score > 0 ? score : 0;
    }
    return 100;
  }

  static int getMaterialScore(String material) {
    return (
        (_materialScores[material]?['recyclability'] ?? 0) * 0.25 +
            (_materialScores[material]?['biodegradability'] ?? 0) * 0.25 +
            (_materialScores[material]?['renewability'] ?? 0) * 0.25 +
            (_materialScores[material]?['reusability'] ?? 0) * 0.25
    ).round();
  }

  static List<String> getMaterialComments(String material) {
    var comments = _materialScores[material]?['comments'] as List<dynamic>?;
    return comments?.map((comment) => comment.toString()).toList() ?? [];
  }

  static String getLabelLogoPath(String label) {
    return 'assets/labels/${label}.png';
  }

  static String getLabelDescription(String label) {
    return _labelDescriptions[label]?['description'] ?? '';
  }

  static int getLabelScore(int nLabels) {
    if (nLabels == 0) return 0;
    if (nLabels == 1) return 50;
    return 100;
  }

  static int getSustainabilityScore(int transportScore, int materialScore, int labelScore) {
    return (transportScore * 0.35 + materialScore * 0.35 + labelScore * 0.3).round();
  }
}