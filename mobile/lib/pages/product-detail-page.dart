import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/Services/product.dart';
import 'package:greenscan/components/loading_screen.dart';
import 'package:greenscan/pages/product_not_found.dart';

import '../utils/location_services.dart';
import '../utils/score_calculation.dart';

class ProductDetailPage extends StatefulWidget {
  final String productCode;
  User user;

  ProductDetailPage({super.key, required this.productCode, required this.user});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
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
  Product product = Product(
      sustainableScore: 0,
      transportScore: 0,
      materialScore: 0,
      labelScore: 0,
      name: "name",
      brand: "brand",
      imageUrl: "imageUrl",
      category: "category",
      country: "country",
      search: "search",
      materials: ["materials"],
      labels: ["labels"]);

  /*
  if (snapshot.exists) {
  // add the scan to the history
  final docRef =
  FirebaseFirestore.instance.collection("users").doc(widget.user.uid);
  final doc = await docRef.get();

  if (!doc.exists) {
  print("couldn't find the user!");
  } else {
  final data = doc.data() as Map<String, dynamic>;
  final historyData;

  if (data.containsKey('history')) {
  historyData = data['history'] as List<String>;

  if (!historyData.contains(widget.productCode)) {
  historyData.add(widget.productCode);

  await docRef.update({
  'history': historyData,
  });
  }
  } else {
  historyData = [widget.productCode];

  await docRef.update({
  'history': historyData,
  });
  }
  }

   */

  @override
  void initState() {
    super.initState();
    fetchProduct();
    LocationService.requestLocationPermission();
    ScoreCalculation.loadJson();
  }

  Future<void> fetchProduct() async {
    try {
      var fetchedProduct = await DataBase.firebaseGetProduct(widget.productCode);
      if (fetchedProduct == null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProductNotFoundPage()));
      } else {
        setState(() {
          product = fetchedProduct;
          isLoading = false;
          progress = product.sustainableScore / 100;
        });
      }
    } catch (e) {
      print('Error fetching product: $e');
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
                  fontWeight: FontWeight.bold)),
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

  Widget buildLabelsContainer(List<String> labels) {
    Practice getPracticeType(int labelCount) {
      if (labelCount == 0) return Practice.bad;
      if (labelCount == 1) return Practice.average;
      return Practice.good;
    }

    IconData icon_ = getIconForPractice(getPracticeType(labels.length));
    Color color_ = getColorForPractice(getPracticeType(labels.length));

    List<Widget> labelEntries = [];
    if (labels.isEmpty) {
      labelEntries.add(
        const ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          title: Text(
            "• No labels found",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
      );
    } else {
      for (int i = 0; i < labels.length; i++) {
        String label = labels[i];
        String description = ScoreCalculation.getLabelDescription(label);
        labelEntries.add(
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset(
                            'assets/labels/${label.toLowerCase()}.png',
                            width: 90,
                            height: 90,
                          ),
                          const Positioned(
                            top: -35,
                            child: Icon(Icons.check_circle, color: Colors.green, size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          description,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < labels.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(color: Colors.grey),
                  ),
              ],
            )
        );
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color_.withOpacity(0.25),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: Icon(
            icon_,
            color: color_,
            size: 28,
          ),
          title: const Text(
            "Labels",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          children: labelEntries,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String material =
        product.materials.isNotEmpty ? product.materials[0] : 'N/A';
    EvaluationContainer productInfo =
        EvaluationContainer("Info", Practice.info, [
      'Name : ${product.name}',
      'Company: ${product.brand}',
      'Category: ${product.category}',
      'Code: ${widget.productCode}'
    ]);

    List<EvaluationContainer> evaluations = [
      EvaluationContainer(
        "Transport",

        getPracticeFromScore(product.transportScore),
        [
          'Score: ${product.transportScore}',
          "Country of Origin: ${product.country}",

          "Delivery is efficient",
          "Packaging is minimal"
        ],
      ),
      EvaluationContainer(
        "Materials",
        getPracticeFromScore(product.materialScore),
        [
          "Score: ${product.materialScore}",
          "Material type: $material",
          ...ScoreCalculation.getMaterialComments(material)
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
        title: Text(product.name),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
                                        builder: (context, value, child) =>
                                            SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CircularProgressIndicator(
                                            value: value,
                                            strokeWidth: 10,
                                            backgroundColor: Colors.grey[200],
                                            color: getSustainabilityColor(
                                                product.sustainableScore),

                                          ),
                                        ),
                                      ),
                                      AnimatedSwitcher(
                                        duration: const Duration(seconds: 2),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                                scale: animation, child: child),
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
                            '${product.sustainableScore.toInt()}%',
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
                          getImpactString(product.sustainableScore),
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
                children: [
                  ...evaluationWidgets,
                  buildLabelsContainer(product.labels)
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
