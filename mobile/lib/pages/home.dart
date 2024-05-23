import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/pages/barcode.dart';
import 'package:greenscan/models/search_model.dart';
import 'package:greenscan/pages/product-detail-page.dart';
import 'package:greenscan/pages/menu.dart';
import 'package:greenscan/models/history_model.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:greenscan/Services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Map<String, String>? productMap;
  Future<List<HistoryModel>>? _historyFuture;

  Future<void> loadProductMap() async {
    productMap = await DataBase.firebaseGetSearchProduct();
  }

  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = GlobalKey();

  List<SearchModel> searches = [];

  void getSearches() {
    searches = SearchModel.getSearch();
  }

  Future<void> scanProduct(BuildContext context) async {
    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeReaderPage()),
    );

    if (barcode != null && barcode.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(productCodes: [barcode]),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _historyFuture = HistoryModel.getHistory(AuthService.user!.uid);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // This code will run every time the app enters the foreground
      _historyFuture = HistoryModel.getHistory(AuthService.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    getSearches();
    return Scaffold(
      drawer: SideBar(),
      appBar: appBar(context),
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            searchMethod(context),
            const SizedBox(height: 20),
            _buildWelcomeBanner(),
            const SizedBox(height: 20),
            _buildSustainabilityTips(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 160.0,
        height: 60.0,
        child: FloatingActionButton(
          onPressed: () => scanProduct(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          backgroundColor: Colors.green,
          child: const Text(
            'Scan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 25,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'GreenScan',
        style: TextStyle(
          color: Colors.black,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.green,
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome to GreenScan!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Redefine your Sustainable Choices Now.',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/homepage-img.jpg', // Placeholder image URL
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityTips() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Vision',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• Reduce, reuse, recycle.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '• Support local and sustainable brands.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '• Choose products with eco-friendly labels.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container searchMethod(BuildContext context) {
    return Container(
      child: FutureBuilder<void>(
        future: loadProductMap(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.11),
                    blurRadius: 40,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: AutoCompleteTextField<String>(
                key: autoCompleteKey,
                suggestions: productMap!.keys.toList(),
                style: const TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: 'Search Product',
                  hintStyle: const TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 18,
                  ),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
                itemFilter: (item, query) {
                  return item.toLowerCase().startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.compareTo(b);
                },
                textSubmitted: (item) {
                  if (productMap![item] != null) {
                    String productId = productMap![item]!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(productCodes: [productId]),
                      ),
                    );
                  }
                },
                itemSubmitted: (item) {
                  if (productMap![item] != null) {
                    String productId = productMap![item]!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(productCodes: [productId]),
                      ),
                    );
                  }
                },
                itemBuilder: (context, item) {
                  return ListTile(
                    title: Text(item),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Column SearchesMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 30),
          child: Text(
            'Recent Searches',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 120,
          child: ListView.separated(
            itemCount: searches.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xff4b986c), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(searches[index].icon),
                      ),
                    ),
                    Text(
                      searches[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
