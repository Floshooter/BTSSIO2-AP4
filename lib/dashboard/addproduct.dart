import 'package:ap4_projet/server/api.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _idCategoryController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();
  final TextEditingController _stocksController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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
              controller: _thumbnailController,
              decoration: const InputDecoration(labelText: 'Thumbnail'),
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
              onPressed: () {
                final Map<String, dynamic> productData = {
                  "id_category": _idCategoryController.text,
                  "item_name": _itemNameController.text,
                  "description": _descriptionController.text,
                  "thumbnail": "", 
                  "stocks": int.parse(_stocksController.text),
                  "price": double.parse(_priceController.text),
                };

                addProduct(productData)
                  .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Produit ajouté avec succès')),
                    );
                  })
                  .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de l\'ajout du produit: $error')),
                    );
                  });
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
