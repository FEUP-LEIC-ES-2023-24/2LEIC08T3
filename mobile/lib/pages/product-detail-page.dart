import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final String productCode;

  const ProductDetailPage({
    super.key,
    required this.productCode,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

enum Practice { good, bad, unknown, info }

class EvaluationContainer {
  final String category;
  final Practice practice;
  final List<String> comments;

  EvaluationContainer(this.category, this.practice, this.comments);
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  double progress = 0;
  int sustainabilityScore = 0;

  @override
  void initState() {
    super.initState();
    fetchSustainabilityScore().then((score) {
      setState(() {
        sustainabilityScore = score;
        progress = sustainabilityScore / 100;
      });
    });
  }

  Future<int> fetchSustainabilityScore() async {
    await Future.delayed(const Duration(seconds: 1));
    return 69;
  }

  Color getSustainabilityColor(int score) {
    if (score >= 50) {
      return Color.lerp(Colors.yellow, Colors.green, (score - 50) / 50)!;
    } else {
      return Color.lerp(Colors.red, Colors.yellow, score / 50)!;
    }
  }

  String getImpactString(int score) {
    if (score >= 80) return 'Impacto Ambiental Muito Baixo';
    if (score >= 60) return 'Impacto Ambiental Baixo';
    if (score >= 40) return 'Impacto Ambiental Moderado';
    if (score >= 20) return 'Impacto Ambiental Alto';
    return 'Impacto Ambiental Muito Alto';
  }

  IconData getIconForPractice(Practice practice) {
    switch (practice) {
      case Practice.good:
        return Icons.check_circle_outline;
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
      case Practice.bad:
        return Colors.red;
      default:
        return Colors.grey;
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
                  fontWeight: FontWeight.bold)
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

  Widget buildGoodBadPractices(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    /* TODO: TEMPS TO BE REPLACED BY FIREBASE DATA */
    const String productName = "Organic Bananas";
    const String companyName = "Nestle";
    const String productImage = "https://media.istockphoto.com/id/173242750/photo/banana-bunch.jpg?s=612x612&w=0&k=20&c=MAc8AXVz5KxwWeEmh75WwH6j_HouRczBFAhulLAtRUU=";
    EvaluationContainer productInfo = EvaluationContainer(
        "Info",
        Practice.info,
        ['Name : $productName', 'Company: $companyName']);

    List<EvaluationContainer> evaluations = [
      EvaluationContainer(
        "Transport",
        Practice.good,
        ["Delivery is efficient", "Packaging is minimal"],
      ),
      EvaluationContainer(
        "Materials",
        Practice.unknown,
        ["Sourcing information not provided"],
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(productName),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              productImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                productName,
                style: TextStyle(
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
                                            color: getSustainabilityColor(sustainabilityScore),
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
                            '${sustainabilityScore.toInt()}%',
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
                          getImpactString(sustainabilityScore),
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
