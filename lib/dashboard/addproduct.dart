import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ap4_projet/server/api.dart';

class AddProductPage extends StatefulWidget {
  final Future<List<dynamic>> futureItems;
  final void Function() onProductAdded;

  const AddProductPage({Key? key, required this.futureItems, required this.onProductAdded}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _idCategoryController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stocksController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _thumbnail;

  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _getFromImageSource(ImageSource.camera),
                  child: const Text('Prendre une photo'),
                ),
                ElevatedButton(
                  onPressed: () => _getFromImageSource(ImageSource.gallery),
                  child: const Text('Choisir depuis la galerie'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getFromImageSource(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _thumbnail = File(pickedFile.path);
        });
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        print("Aucune image sélectionnée.");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _addProduct() async {
    Map<String, dynamic> productData = {
      'id_category': int.parse(_idCategoryController.text),
      'item_name': _itemNameController.text,
      'description': _descriptionController.text,
      'stocks': int.parse(_stocksController.text),
      'price': int.parse(_priceController.text),
    };

    try {
      await addProduct(_thumbnail, productData);
      widget.onProductAdded();
      Navigator.pop(context); // Ferme la page d'ajout
    } catch (e) {
      print('Erreur lors de l\'ajout du produit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _showImageSourceDialog,
              child: const Text('Ajouter une image'),
            ),
            if (_thumbnail != null) ...[
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.file(_thumbnail!),
                ),
              ),
            ],
            TextFormField(
              controller: _idCategoryController,
              decoration: const InputDecoration(labelText: 'ID Category'),
            ),
            TextFormField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Nom du produit'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _stocksController,
              decoration: const InputDecoration(labelText: 'Stocks'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
