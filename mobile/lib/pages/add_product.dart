import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/Services/product.dart';
import 'package:greenscan/models/dialog_modal.dart';
import 'package:greenscan/pages/product-detail-page.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  String? category;
  String? selectedMaterial;
  final List<String> labels = [];
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  final List<String> materials = [
    "Paper",
    "Cardboard",
    "Glass",
    "Aluminum",
    "Steel",
    "Plastic PET",
    "Plastic HDPE",
    "Plastic PVC",
    "Plastic LDPE",
    "Plastic PP",
    "Plastic PS",
    "Bioplastics",
    "Mixed"
  ];

  final List<String> categories = [
    "Snacks",
    "Fruits and Vegetables",
    "Beverages",
    "Dairies",
    "Cereal and Potatoes",
    "Meats",
    "Fermented Foods",
    "Meals",
    "Condiments",
    "Other"
  ];

  final List<String> availableLabels = [
    "Carbon Trust",
    "EU Organic",
    "Fairtrade",
    "Forest Stewardship Council (FSC)",
    "Green Dot",
    "Rainforest Alliance"
  ];

  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () async {
                final XFile? pickedFile =
                await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, pickedFile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                final XFile? pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, pickedFile);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.green.shade700),
    );
  }

  Widget _buildCheckboxTile(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: labels.contains(label) ? Colors.green[400] : Colors.green[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: labels.contains(label) ? Colors.white : Colors.black87,
          ),
        ),
        onTap: () {
          setState(() {
            if (labels.contains(label)) {
              labels.remove(label);
            } else {
              labels.add(label);
            }
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_image != null)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.file(File(_image!.path), fit: BoxFit.cover),
          ),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text("Pick Image"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  String? convertStringToJson(String string) {
    return string.toLowerCase().replaceAll(' ', '_');
  }

  Future<bool> _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      List<String> formattedLabels = labels.map((label) => convertStringToJson(label)!).toList();

      await DataBase.firebaseAddProduct(
          _idController.text.trim(),
          Product(
              sustainableScore: 0,
              transportScore: 0,
              materialScore: 0,
              labelScore: 0,
              name: _nameController.text.trim(),
              brand: _brandController.text.trim(),
              imageUrl: _image!.path,
              category: category!,
              country: _countryController.text.trim(),
              search: _nameController.text.trim().toLowerCase(),
              materials: [convertStringToJson(selectedMaterial!)!],
              labels: formattedLabels,
              stores: []
          ),
          _image
      );
      DialogModal.showCustomDialog(context, true, "Product has been added successfully!", () {
        Navigator.of(context).pop();  // Exit Add Product Page
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(productCodes: [_idController.text.trim()])));  // Navigate to Product Detail Page
      });

      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please complete the form before submitting.')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _idController,
                decoration: _buildDecoration('Product ID'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter an ID' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: _buildDecoration('Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: _buildDecoration('Brand'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a brand' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                decoration: _buildDecoration('Category'),
                onChanged: (String? newValue) =>
                    setState(() => category = newValue),
                items: categories
                    .map<DropdownMenuItem<String>>((String value) =>
                    DropdownMenuItem<String>(
                        value: value, child: Text(value)))
                    .toList(),
                validator: (value) =>
                value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: _buildDecoration('Country of Origin'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a country of origin' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMaterial,
                decoration: _buildDecoration('Material'),
                onChanged: (String? newValue) =>
                    setState(() => selectedMaterial = newValue),
                items: materials
                    .map<DropdownMenuItem<String>>((String value) =>
                    DropdownMenuItem<String>(
                        value: value, child: Text(value)))
                    .toList(),
                validator: (value) =>
                value == null ? 'Please select a material' : null,
              ),
              const SizedBox(height: 16),
              const Text('Select Labels:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              ...availableLabels.map((label) => _buildCheckboxTile(label)),
              const SizedBox(height: 24),
              _buildImagePicker(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (await _submitForm()) {
                      _formKey.currentState!.reset();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Add Product"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
