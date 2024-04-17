import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String barcode;
  final String name;
  final String description;
  final double price;
  final String category;
  final String brand;
  final String imageUrl;

  Product({
    required this.barcode,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'brand': brand,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String barcode) {
    return Product(
      barcode: barcode,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final String barcode;

  ProductDetailsPage({required this.barcode});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product? _fetchedProduct;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    setState(() {
      _isLoading = true;
    });

    final docRef =
        FirebaseFirestore.instance.collection('items').doc(widget.barcode);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      setState(() {
        _fetchedProduct = Product.fromMap(docSnapshot.data()!, widget.barcode);
        //print(docSnapshot.data()!);
      });
    } else {
      // Handle product not found
      print('Product not found');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text(
                widget.barcode,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              if (_isLoading) CircularProgressIndicator(),
              if (_fetchedProduct != null)
                _buildProductInfo(_fetchedProduct!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      children: [
        Text('Name: ${product.name}', style: TextStyle(fontSize: 20)),
        Text('Description: ${product.description}', style: TextStyle(fontSize: 20)),
        Text('Brand: ${product.brand}', style: TextStyle(fontSize: 20)),
        Text('Price: ${product.price}\$', style: TextStyle(fontSize: 20)),
        Text('Category: ${product.category}', style: TextStyle(fontSize: 20)),
        Text('Image URL: ${product.imageUrl}', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

class CreateProductPage extends StatefulWidget {
  final String barcode;
  CreateProductPage({required this.barcode});
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  double _price = 0.0;
  String _category = '';
  String _brand = '';
  String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                onSaved: (value) {
                  _category = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Brand'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a brand';
                  }
                  return null;
                },
                onSaved: (value) {
                  _brand = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _imageUrl = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final newProduct = Product(
      barcode: widget.barcode,
      name: _name,
      description: _description,
      price: _price,
      category: _category,
      brand: _brand,
      imageUrl: _imageUrl,
    );

    _saveProduct(newProduct);
  }

  Future<void> _saveProduct(Product product) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('items').doc(widget.barcode);
      await docRef.set(product.toMap());
      print('Product created successfully');
      Navigator.of(context).pop();
    } catch (error) {
      print('Failed to create product: $error');
    }
  }
}
