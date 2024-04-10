// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

String url = 'http://10.74.2.81:8001';

Future<Map<String, dynamic>> authenticateUser(String email, String password) async {
  String loginUrl = '$url/users/login';

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  http.Response response = await http.post(
    Uri.parse(loginUrl),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> userData = jsonDecode(response.body);
    
    int permLevel = userData['user']['permLevel'] as int;
    if (permLevel == 1 || permLevel == 2) {
      return userData;
    } else {
      throw Exception('Permission insuffisante pour accéder à l\'application');
    }
  } else if (response.statusCode == 404) {
    throw Exception('Utilisateur non trouvé');
  } else {
    throw Exception('Mot de passe incorrect');
  }
}

Future<List<dynamic>> fetchUsers() async {
  String usersUrl = '$url/users';
  
  final response = await http.get(Uri.parse(usersUrl));
  if (response.statusCode == 200) {
    return List<dynamic>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load users');
  }
}

Future<List<dynamic>> fetchItems() async {
  String itemUrl = '$url/boutique';

  final response = await http.get(Uri.parse(itemUrl));
  if (response.statusCode == 200) {
    return List<dynamic>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load items');
  }
}


Future<void> addUser(Map<String, dynamic> userData) async {
  String addEmployeeUrl = '$url/users/addemployee'; ///boutique/addItem

  final response = await http.post(
    Uri.parse(addEmployeeUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(userData),
  );

  if (response.statusCode == 200) {
    // L'utilisateur a été ajouté avec succès
    print('Utilisateur ajouté avec succès');
  } else {
    // Une erreur s'est produite lors de l'ajout de l'utilisateur
    throw Exception('Erreur lors de l\'ajout de l\'utilisateur');
  }
}
Future<void> addProduct(Map<String, dynamic> productData) async {
  String addProductUrl = '$url/boutique/additem';

  final response = await http.post(
    Uri.parse(addProductUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(productData),
  );

  if (response.statusCode == 200) {
    // Le produit a été ajouté avec succès
    print('Produit ajouté avec succès');
  } else {
    // Une erreur s'est produite lors de l'ajout du produit
    throw Exception('Erreur lors de l\'ajout du produit');
  }
}

Future<void> deleteUser(int userId) async {
  String deleteUserUrl = '$url/users/deleteUser/$userId';

  final response = await http.delete(
    Uri.parse(deleteUserUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // L'utilisateur a été supprimé avec succès
    print('Utilisateur supprimé avec succès');
  } else {
    // Une erreur s'est produite lors de la suppression de l'utilisateur
    throw Exception('Erreur lors de la suppression de l\'utilisateur');
  }
}
Future<void> deleteProduct(int productId) async {
  String deleteProductUrl = '$url/boutique/deleteitem/$productId';

  final response = await http.delete(
    Uri.parse(deleteProductUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // L'utilisateur a été supprimé avec succès
    print('Produit supprimé avec succès');
  } else {
    // Une erreur s'est produite lors de la suppression de l'utilisateur
    throw Exception('Erreur lors de la suppression du produit');
  }
}
Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
  String updateUserUrl = '$url/users/updateUser/$userId';

  final response = await http.put(
    Uri.parse(updateUserUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(userData),
  );

  if (response.statusCode == 200) {
    // L'utilisateur a été mis à jour avec succès
    print('Utilisateur mis à jour avec succès');
  } else {
    // Une erreur s'est produite lors de la mise à jour de l'utilisateur
    throw Exception('Erreur lors de la mise à jour de l\'utilisateur');
  }
}
Future<void> updateProduct(int productId, Map<String, dynamic> productData) async {
  String updateProductUrl = '$url/boutique/updateitem/$productId';

  final response = await http.put(
    Uri.parse(updateProductUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(productData),
  );

  if (response.statusCode == 200) {
    // Le produit a été mis à jour avec succès
    print('Produit mis à jour avec succès');
  } else {
    // Une erreur s'est produite lors de la mise à jour du produit
    throw Exception('Erreur lors de la mise à jour du produit');
  }
}

