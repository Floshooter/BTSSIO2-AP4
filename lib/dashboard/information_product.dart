// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProductInformationPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductInformationPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['item_name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('ID', product['id'].toString()),
            _buildInfoRow('Nom', product['item_name']),
            _buildInfoRow('Description', product['description']),
            _buildInfoRow('Prix', '${product['price']} €'),
            _buildInfoRow('Stocks restants', product['stocks'].toString()),
            _buildInfoRow('Catégorie', product['id_category'].toString()),
            _buildInfoRow('Thumbnail', product['thumbnail']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
