import 'package:greenscan/Services/store.dart';
import 'package:greenscan/utils/score_calculation.dart';
import 'package:greenscan/utils/location_services.dart';

import 'firebase.dart';

class Product {
  // calculate runtime
  final int sustainableScore;
  final int transportScore;
  final int materialScore;
  final int labelScore;

  //from database
  final String name;
  final String brand;
  final String imageUrl;
  final String category;
  final String country;
  final String search;
  final List<String> materials;
  final List<String> labels;
  final List<String> stores;

  Product(
      {required this.sustainableScore,
      required this.transportScore,
      required this.materialScore,
      required this.labelScore,
      required this.name,
      required this.brand,
      required this.imageUrl,
      required this.category,
      required this.country,
      required this.search,
      required this.materials,
      required this.stores,
      required this.labels});

  static Future<Product?> buildProductDB(Map<String, dynamic>? data) async {
    if (data == null) return null;
    if (!(data.containsKey("brand") ||
        data.containsKey("category") ||
        data.containsKey("country") ||
        data.containsKey("imageUrl") ||
        data.containsKey("labels") ||
        data.containsKey("materials") ||
        data.containsKey("name") ||
        data.containsKey("search") ||
        data.containsKey("stores"))) return null;

    int transportScore_ = 0;
    int materialScore_ = 0;
    int sustainableScore_ = 0;
    int labelScore_ = 0;

    final country_ = data['country'];
    final materials_ = (data['materials'] as List<dynamic>)
        .where((material) => material is String)
        .cast<String>()
        .toList();
    final labels_ = (data['labels'] as List<dynamic>)
        .where((labels) => labels is String)
        .cast<String>()
        .toList();
    final stores_ = (data['stores'] as List<dynamic>)
        .where((stores) => stores is String)
        .cast<String>()
        .toList();

    double? distance;
    try {
      distance = await LocationService.getDistanceToCountry(country_);
      if (distance == null) {
        print("invalid distance");
        return null;
      }
      transportScore_ = ScoreCalculation.getTransportScore(distance).toInt();
    } catch (error) {
      print("Error calculating transport score: $error");
      return null;
    }

    //TODO change to array of materials
    materialScore_ = ScoreCalculation.getMaterialScore(materials_[0]);

    labelScore_ = ScoreCalculation.getLabelScore(labels_.length);

    sustainableScore_ = ScoreCalculation.getSustainabilityScore(
        transportScore_, materialScore_, labelScore_);

    return Product(
        sustainableScore: sustainableScore_,
        transportScore: transportScore_,
        materialScore: materialScore_,
        labelScore: labelScore_,
        name: data['name'],
        brand: data['brand'],
        imageUrl: data['imageUrl'],
        category: data['category'],
        country: country_,
        search: data['search'],
        materials: materials_,
        labels: labels_, 
        stores: stores_);
        }

  Future<List<Store>> getProductStores() async {
    List<Store> stores = [];

    for (var code in this.stores) {
      Store? store = await DataBase.firebaseGetStore(code);
      if (store != null) stores.add(store);
    }

    return stores;
  } 
}
