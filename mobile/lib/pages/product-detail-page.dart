import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/Services/product.dart';
import 'package:greenscan/components/loading_screen.dart';
import 'package:greenscan/pages/product_not_found.dart';
import 'package:greenscan/pages/google-maps.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Services/store.dart';
import '../utils/location_services.dart';
import '../utils/score_calculation.dart';
import 'barcode.dart';

class ProductDetailPage extends StatefulWidget {
  final List<String> productCodes;

  ProductDetailPage({super.key, required this.productCodes });

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
  List<Product> products = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    LocationService.requestLocationPermission();
    ScoreCalculation.loadJson();
  }

  Future<void> fetchProducts() async {
    List<Product> fetchedProducts = [];
    for (String productCode in widget.productCodes) {
      try {
        var fetchedProduct = await DataBase.firebaseGetProduct(productCode);
        if (fetchedProduct == null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProductNotFoundPage()));
          break;
        }

        for (var code in fetchedProduct.stores) {
          var store = await DataBase.firebaseGetStore(code);
          print(store);
        }

        if (fetchedProduct != null) {
          fetchedProducts.add(fetchedProduct);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductNotFoundPage()));
        }
      } catch (e) {
        print('Error fetching product: $e');
      }
    }

    setState(() {
      products = fetchedProducts;
      isLoading = false;
      if (products.isNotEmpty) {
        progress = products.first.sustainableScore / 100;
      }
    });
  }

  void _showStoreSelection(List<Store> stores) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Available Stores'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var store in stores)
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.store),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleMapsPage(
                          storePosition: LatLng(store.latitude, store.longitude),
                        ),
                      ),
                    );
                  },
                ),
                title: Text(store.name),
              ),
          ],
        ),
      ),
    );
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

  Future<void> _addNewProduct() async {
    isLoading = true;
    try {
      final barcode = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarcodeReaderPage()),
      );
      var newProduct = await DataBase.firebaseGetProduct(barcode);
      setState(() {
        products.add(newProduct as Product);
      });
      isLoading = false;
    } catch (e) {
      print('Error adding new product: $e');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CustomLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                String material = product.materials.isNotEmpty ? product.materials[0] : 'N/A';

                EvaluationContainer productInfo = EvaluationContainer("Info", Practice.info, [
                  'Name : ${product.name}',
                  'Company: ${product.brand}',
                  'Category: ${product.category}',
                  'Code: ${product.stores.isNotEmpty ? product.stores.first : 'N/A'}' // Update to get the correct code
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

                return SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
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
                                                          color: getSustainabilityColor(product.sustainableScore),
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
                      const SizedBox(height: 25),
                      Center(
                        child: SizedBox(
                          width: 220,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              List<Store> stores = [];
                              try {
                                stores = await product.getProductStores();
                              } catch (e) {
                                print('Error getting stores: $e');
                              }
                              _showStoreSelection(stores);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Center(
                              child: Text(
                                'Available Stores',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addNewProduct,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text("Compare Product"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: products.length,
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.green,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
