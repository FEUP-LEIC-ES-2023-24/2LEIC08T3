import 'package:greenscan/utils/score_calculation.dart';
import 'package:greenscan/utils/location_services.dart';

class Product {
  // SCORES
  final int sustainableScore;
  final int transportScore;
  final int materialScore;

  final String name;
  final String brand;
  final String imageUrl;
  final String category;
  final String country;
  final List<String> materials;
  final String search;

  Product({
    required this.sustainableScore,
    required this.transportScore,
    required this.materialScore,

    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.category,
    required this.country,
    required this.materials,
    required this.search
  });


  static Future<Product> buildProduct(Map<String, dynamic> data) async {

    var transportScore_ = data['transportScore'];
    var materialScore_ = data['materialScore'];
    final country_ = data['country'];
    final materials_ = List<String>.from(data['materials'] as List<dynamic> ?? []);

    if (transportScore_ < 0 || transportScore_ > 100) {
      double? distance;
      try {
        distance = await LocationService.getDistanceToCountry(country_);
        if (distance == null) {
          throw Exception("invalid distance");
        }
        transportScore_ = ScoreCalculation.computeTransportScore(distance);
      } catch (error) {
        throw Exception("Error calculating transport score: $error");
      }
    }

    if (materialScore_ < 0 || materialScore_ > 100) {
      if (materials_.isEmpty) throw Exception("materials empty");

      for (var material in materials_) {
        materialScore_ += ScoreCalculation.getMaterialRecyclability(material);
      }
      materialScore_ /= materials_.length;
    }

    if (transportScore_ is double) {
      transportScore_ = transportScore_.toInt();
    }

    if (materialScore_ is double) {
      materialScore_ = (materialScore_ + 1).toInt();
    }

    return Product(
        sustainableScore: data['sustainableScore'] ?? 0, // if -1, means it hasn't been calculated
        transportScore: transportScore_ ?? 0,
        materialScore: materialScore_ ?? 0,

        name: data['name'] ?? 'Unknown Product',
        brand: data['brand'] ?? 'Unknown Brand',
        imageUrl: data['imageUrl'] ?? 'default_image_url',
        category: data['category'] ?? 'Unknown Category',
        country: country_ ?? 'Unknown Country',
        materials: materials_,
        search: data['search'] ?? ''
    );
  }

  Product copyWith({
    int? sustainableScore,
    int? transportScore,
    int? materialScore,
    String? name,
    String? brand,
    String? imageUrl,
    String? category,
    String? country,
    List<String>? materials
  }) {
    return Product(
      sustainableScore: sustainableScore ?? this.sustainableScore,
      transportScore: transportScore ?? this.transportScore,
      materialScore: materialScore ?? this.materialScore,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      country: country ?? this.country,
      materials: materials ?? this.materials,
      search: search ?? this.search,
    );
  }
}