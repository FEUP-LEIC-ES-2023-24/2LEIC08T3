import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/components/loading_screen.dart';

import '../utils/location_services.dart';
import '../utils/score_calculation.dart';

class ProductDetailPage extends StatefulWidget {
  final String productCode;

  const ProductDetailPage({
    required this.productCode,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class ProductDetails {
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

  ProductDetails({
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

  factory ProductDetails.fromFirestore(Map<String, dynamic> data) {
    return ProductDetails(
      sustainableScore: data['sustainableScore'] ?? 0, // if -1, means it hasn't been calculated
      transportScore: data['transportScore'] ?? 0,
      materialScore: data['materialScore'] ?? 0,

      name: data['name'] ?? 'Unknown Product',
      brand: data['brand'] ?? 'Unknown Brand',
      imageUrl: data['imageUrl'] ?? 'default_image_url',
      category: data['category'] ?? 'Unknown Category',
      country: data['country'] ?? 'Unknown Country',
      materials: List<String>.from(data['materials'] as List<dynamic> ?? []),
      search: data['search'] ?? '' 
    );
  }

  ProductDetails copyWith({
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
    return ProductDetails(
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

enum Practice { good, average, bad, unknown, info }

class EvaluationContainer {
  final String category;
  final Practice practice;
  final List<String> comments;

  EvaluationContainer(this.category, this.practice, this.comments);
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  double progress = 0;
  bool isLoading = true;
  ProductDetails productDetails = ProductDetails(
      sustainableScore: 0, transportScore: 0, materialScore: 0,
      name: '', brand: '', imageUrl: '', category: '', country: '', materials: [], search: '');

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    LocationService.requestLocationPermission();
    ScoreCalculation.loadMaterialScores();
  }

  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.productCode)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        productDetails = ProductDetails.fromFirestore(data);

        if (productDetails.transportScore == -1) {
          double? distance = await LocationService.getDistanceToCountry(productDetails.country);
          if (distance != null) {
            double calculatedScore = ScoreCalculation.computeTransportScore(distance);
            productDetails = productDetails.copyWith(transportScore: calculatedScore.truncate());
          }
        }

        print(ScoreCalculation.getMaterialRecyclability(productDetails.materials[0]));
        if (productDetails.materialScore == -1) {
          int score = ScoreCalculation.getMaterialRecyclability(productDetails.materials[0]);
          productDetails = productDetails.copyWith(materialScore: score);

        }
        
        setState(() {
          progress = productDetails.sustainableScore / 100;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching product details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getSustainabilityColor(int score) {
    if (score >= 50) {
      return Color.lerp(Colors.yellow, Colors.green, (score - 50) / 50)!;
    } else {
      return Color.lerp(Colors.red, Colors.yellow, score / 50)!;
    }
  }

  String getImpactString(int score) {
    if (score >= 80) return 'Very Low Environmental Impact';
    if (score >= 60) return 'Low Environmental Impact';
    if (score >= 40) return 'Moderate Environmental Impact';
    if (score >= 20) return 'High Environmental Impact';
    return 'Extreme Environmental Impact';
  }

  IconData getIconForPractice(Practice practice) {
    switch (practice) {
      case Practice.good:
        return Icons.check_circle_outline;
      case Practice.average:
        return Icons.thumbs_up_down_outlined;
      case Practice.bad:
        return Icons.cancel_outlined;
      case Practice.info:
        return Icons.info_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color getColorForPractice(Practice practice) {
    switch (practice) {
      case Practice.good:
        return Colors.green;
      case Practice.average:
        return Colors.yellow;
      case Practice.bad:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Practice getPracticeFromScore(int score) {
    if (score < 30) {
      return Practice.bad;
    } else if (score < 70) {
      return Practice.average;
    } else {
      return Practice.good;
    }
  }

  Widget buildEvaluationContainer(EvaluationContainer evaluation) {
    bool isExpanded = false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: getColorForPractice(evaluation.practice).withOpacity(0.25),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() => isExpanded = expanded);
          },
          initiallyExpanded: isExpanded,
          leading: Icon(
            getIconForPractice(evaluation.practice),
            color: getColorForPractice(evaluation.practice),
            size: 28,
          ),
          title: Text(evaluation.category,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              )
          ),
          childrenPadding: const EdgeInsets.all(6.0),
          children: evaluation.comments
              .map((comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Text(
                            "• $comment",
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* TODO: TEMPS TO BE REPLACED BY FIREBASE DATA */
    EvaluationContainer productInfo = EvaluationContainer(
        "Info",
        Practice.info,
        ['Name : ${productDetails.name}', 'Company: ${productDetails.brand}', 'Category: ${productDetails.category}', 'Code: ${widget.productCode}']);

    List<EvaluationContainer> evaluations = [
      EvaluationContainer(
        "Transport",
        getPracticeFromScore(productDetails.transportScore),
        ['Score: ${productDetails.transportScore}', "Country of Origin: ${productDetails.country}", "Delivery is efficient", "Packaging is minimal"],
      ),
      EvaluationContainer(
        "Materials",
        getPracticeFromScore(productDetails.materialScore),
        ["Score: ${productDetails.materialScore}", "Material type: ${productDetails.materials}", "Very Recyclable"],
      ),
      EvaluationContainer(
        "Labels",
        Practice.bad,
        [
          "Certifications are lacking",
          "Incomplete product information"
        ],
      ),
    ];

    List<Widget> evaluationWidgets = evaluations
        .map((evaluation) => buildEvaluationContainer(evaluation))
        .toList();

    if (isLoading) {
      return const CustomLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(productDetails.name),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              productDetails.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                productDetails.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color:
                      Colors.black87,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: progress),
                                        duration: const Duration(seconds: 2),
                                        builder: (context, value, child) => SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CircularProgressIndicator(
                                            value: value,
                                            strokeWidth: 10,
                                            backgroundColor: Colors.grey[200],
                                            color: getSustainabilityColor(productDetails.sustainableScore),
                                          ),
                                        ),
                                      ),
                                      AnimatedSwitcher(
                                        duration: const Duration(seconds: 2),
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(scale: animation, child: child),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${productDetails.sustainableScore.toInt()}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                        color: Colors.black38, thickness: 1, width: 32),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          getImpactString(productDetails.sustainableScore),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildEvaluationContainer(productInfo),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                "Sustainable Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    evaluationWidgets,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
