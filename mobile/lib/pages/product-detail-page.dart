import 'package:flutter/material.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/components/loading_screen.dart';

import '../utils/location_services.dart';
import '../utils/score_calculation.dart';

import 'package:greenscan/Services/product.dart';

class ProductDetailPage extends StatefulWidget {
  final String productCode;

  const ProductDetailPage({
    required this.productCode,
  });


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
      name: "name",
      brand: "brand",
      imageUrl: "imageUrl",
      category: "category",
      country: "country",
      search: "search",
      materials: ["materials"],
      labels: ["labels"]);

  /*
  void _showStoreSelection() {
    fetchStoresForProduct(); // Fetch store data when the button is pressed
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Available Stores'),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Keep dialog compact
          children: [
            // Show stores based on the fetched data
            for (var store in stores)
              ListTile(
                title: Text(store['name']),
                subtitle: Text(store['location']),
              ),
          ],
        ),
      ),
    );
  }

   */


  @override
  void initState() {
    super.initState();
    LocationService.requestLocationPermission();
    ScoreCalculation.loadMaterialScores();
    fetchProduct();
  }

  /*
  Future<void> fetchStoresForProduct() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.productCode)
          .get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        var storesData = data['lojas'] as List<dynamic>; // Assuming 'lojas' is the field containing store data

        // Fetch details of each store
        for (var storeRef in storesData) {
          DocumentSnapshot storeSnapshot = await storeRef.get();
          if (storeSnapshot.exists) {
            var storeData = storeSnapshot.data() as Map<String, dynamic>;
            stores.add({
              'name': storeData['name'],
              'location': storeData['location'],
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching stores for product: $e');
    }
  }
   */


  Future<void> fetchProduct() async {
    try {
      var fetchedProduct =
          await DataBase.firebaseGetProduct(widget.productCode);
      setState(() {
        product = fetchedProduct;
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    /* TODO: TEMPS TO BE REPLACED BY FIREBASE DATA */
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
          "Material type: ${product.materials}",
          "Very Recyclable"
        ],
      ),
      EvaluationContainer(
        "Labels",
        Practice.bad,
        ["Certifications are lacking", "Incomplete product information"],
      ),
    ];

    /*
    ElevatedButton(
      onPressed: () {
        _showStoreSelection();
      },
      child: const Text('Stores')
    );

     */

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
                children: evaluationWidgets,
              ),
            ),
            const SizedBox(height: 32),
            /*
            ElevatedButton(
              onPressed: _showStoreSelection,
              child: const Text('Escolher Loja'),
            ),

             */
          ],
        ),
      ),
    );
  }
}
