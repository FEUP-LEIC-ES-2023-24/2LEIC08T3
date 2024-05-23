import 'package:flutter/material.dart';
import 'package:greenscan/pages/barcode.dart';
import 'package:greenscan/pages/product-detail-page.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/Services/product.dart';
import 'package:greenscan/pages/product_not_found.dart';

import '../components/loading_screen.dart';

class ProductComparatorPage extends StatefulWidget {
  @override
  _ProductComparatorPage createState() => _ProductComparatorPage();
}

class _ProductComparatorPage extends State<ProductComparatorPage> {
  List<Product> products = [];
  List<String> productIds = [];
  bool isLoading = false;

  Future<void> _addProduct() async {
    try {
      final barcode = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarcodeReaderPage()),
      );

      if (barcode != null && barcode.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var newProduct = await DataBase.firebaseGetProduct(barcode);

        if (newProduct != null) {
          setState(() {
            products.add(newProduct as Product);
            productIds.add(barcode);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductNotFoundPage()),
          );
        }
      }
      isLoading = false;
    } catch (e) {
      print('Error adding new product: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  void _proceed() {
    if (products.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(productCodes: productIds),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Products'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const CustomLoadingScreen()
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.green.withOpacity(0.5), const Color(0x664b5747)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                            product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.brand, style: const TextStyle(color: Colors.black54)),
                            Text(
                              productIds[index],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (products.length < 8)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton.icon(
                onPressed: _proceed,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Proceed'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
