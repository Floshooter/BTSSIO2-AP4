import 'package:flutter/material.dart';

class ProductInformationPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductInformationPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['item_name']),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('ID', product['id_items'].toString()),
            _buildInfoRow('Nom', product['item_name']),
            _buildInfoRow('Description', product['description']),
            _buildInfoRow('Prix', '${product['price']} €'),
            _buildInfoRow('Stocks restants', product['stocks'].toString()),
            _buildInfoRow('Catégorie', product['id_category'].toString()),
            SizedBox(
              height: 200, // Ajustez la hauteur selon vos besoins
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Couleur de fond du cadre
                  border: Border.all(color: Colors.grey[400]!), // Couleur de la bordure
                  borderRadius: BorderRadius.circular(20.0), // Rayon de la bordure
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0), // Rayon de la bordure du contenu
                  child: Image.network(
                    'http://192.168.1.28:8001/upload/${product['thumbnail']}',
                    fit: BoxFit.cover, // Ajustez le mode de remplissage selon vos besoins
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200], // Couleur de fond de la page
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo, // Couleur du texte
                fontSize: 16, // Taille du texte
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800], // Couleur du texte
                fontSize: 16, // Taille du texte
              ),
            ),
          ),
        ],
      ),
    );
  }
}
