import 'package:flutter/material.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/pages/barcode.dart';
import 'package:greenscan/models/inventory_model.dart';
import 'package:greenscan/models/search_model.dart';
import 'package:greenscan/pages/product-detail-page.dart';
import 'package:greenscan/pages/menu.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class HomePage extends StatelessWidget {
  Map<String, String>? productMap;

  Future<void> loadProductMap() async {
    productMap = await DataBase.firebaseGetSearchProduct();
  }

  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = GlobalKey();

  List<SearchModel> searches = [];
  List<InventoryModel> inventory = [];

  void getSearches() {
    searches = SearchModel.getSearch();
  }

  void getInventory() {
    inventory = InventoryModel.getInventory();
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
  Widget build(BuildContext context) {
    getSearches();
    return Scaffold(
      drawer: SideBar(),
      appBar: appBar(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchMethod(context),
            const SizedBox(height: 10),
            SearchesMethod(),
            const SizedBox(height: 20),
            InventoryMethod(),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 160.0,
        height: 60.0,
        child: FloatingActionButton(
          onPressed: () => scanProduct(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          backgroundColor: const Color(0xff4b986c),
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
    );
  }

  Container searchMethod(BuildContext context) {
    return Container(
        child: FutureBuilder<void>(
            future: loadProductMap(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading spinner while waiting
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                  margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
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
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
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
                      String productId = productMap![item]!;
                      print(productId);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              productCodes: [productId],
                            ),
                          ));
                    },

                    itemSubmitted: (item) {
                      String productId = productMap![item]!;
                      print(productId);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              productCodes: [productId],
                            ),
                          ));
                    },

                    itemBuilder: (context, item) {
                      return ListTile(
                        title: Text(item),
                      );
                    },
                  ),
                );
              }
            }));
  }

  Column SearchesMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 30),
          child: Text(
            'Recent searched',
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
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xff4b986c), width: 2),
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

  Column InventoryMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 30),
          child: Text(
            'Inventory',
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
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xff4b986c), width: 2),
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

