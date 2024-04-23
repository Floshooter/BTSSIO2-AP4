// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String url = 'http://192.168.1.28:8001'; //Serveur SISR IPSSI

class UserData {
  static Map<String, dynamic>? userDataConnected;
}

Future<Map<String, dynamic>> authenticateUser(String email, String password) async {
  String loginUrl = '$url/users/login';

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  try {
    http.Response response = await http.post(
      Uri.parse(loginUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> userDataConnected = jsonDecode(response.body);
      debugPrint('token : ${userDataConnected['token']}');
      debugPrint('userData: ${userDataConnected['user']}');

      UserData.userDataConnected = userDataConnected;
      

      int permLevel = userDataConnected['user']['permLevel'] as int;
      if (permLevel == 1 || permLevel == 2) {
        return userDataConnected;
      } else {
        throw Exception('Permission insuffisante pour accéder à l\'application');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Utilisateur non trouvé');
    } else {
      throw Exception('Mot de passe incorrect');
    }
  } catch (e) {
    throw Exception('Erreur lors de l\'authentification : $e');
  }
}

Future<List<dynamic>> fetchUsers() async {
  String usersUrl = '$url/users';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Token invalide ou expiré');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken,
    };

    final response = await http.get(Uri.parse(usersUrl), headers: headers);

    if (response.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      // Le token est invalide ou a expiré, donc on le supprime
      throw Exception('Utilisateur non connecté');
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors du chargement des utilisateurs : $e');
  }
}


Future<List<dynamic>> fetchItems() async {
  String itemUrl = '$url/boutique';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Token invalide ou expiré');
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken,
    };

    http.Response response = await http.get(Uri.parse(itemUrl), headers: headers);

    if (response.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load items: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors du chargement des articles : $e');
  }
}
// Future<List<dynamic>> fetchItemsByName(String value) async {
//   String productNameUrl = '$url/boutique/s?name=$value';

//   final response = await http.get(Uri.parse(productNameUrl));
//   if (response.statusCode == 200) {
//     return List<dynamic>.from(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load items by name');
//   }
// }


Future<void> addUser(Map<String, dynamic> userData) async {
  String addEmployeeUrl = '$url/users/addemployee';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Utilisateur non connecté');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.post(
      Uri.parse(addEmployeeUrl),
      headers: headers,
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      print('Utilisateur ajouté avec succès');
    } else {
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors de l\'ajout de l\'utilisateur : $e');
  }
}

Future<void> addProduct(Map<String, dynamic> productData) async {
  String addProductUrl = '$url/boutique/additem';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Utilisateur non connecté');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.post(
      Uri.parse(addProductUrl),
      headers: headers,
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200) {
      print('Produit ajouté avec succès');
    } else {
      throw Exception('Erreur lors de l\'ajout du produit: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors de l\'ajout du produit : $e');
  }
}


Future<void> deleteUser(int userId) async {
  String deleteUserUrl = '$url/users/deleteUser/$userId';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Utilisateur non connecté');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.delete(
      Uri.parse(deleteUserUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Utilisateur supprimé avec succès');
    } else {
      throw Exception('Erreur lors de la suppression de l\'utilisateur: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors de la suppression de l\'utilisateur : $e');
  }
}

Future<void> deleteProduct(int productId) async {
  String deleteProductUrl = '$url/boutique/deleteitem/$productId';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Utilisateur non connecté');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.delete(
      Uri.parse(deleteProductUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Produit supprimé avec succès');
    } else {
      throw Exception('Erreur lors de la suppression du produit: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors de la suppression du produit : $e');
  }
}
Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
  String updateUserUrl = '$url/users/updateUser/$userId';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Utilisateur non connecté');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.put(
      Uri.parse(updateUserUrl),
      headers: headers,
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      print('Utilisateur mis à jour avec succès');
    } else {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors de la mise à jour de l\'utilisateur : $e');
  }
}

Future<void> updateProduct(int productId, Map<String, dynamic> productData) async {
  String updateProductUrl = '$url/boutique/updateitem/$productId';

  try {
    String? authToken = UserData.userDataConnected?['token'];
    if (authToken == null) {
      throw Exception('Utilisateur non connecté');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.put(
      Uri.parse(updateProductUrl),
      headers: headers,
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200) {
      // Le produit a été mis à jour avec succès
      print('Produit mis à jour avec succès');
    } else {
      // Une erreur s'est produite lors de la mise à jour du produit
      throw Exception('Erreur lors de la mise à jour du produit: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur lors de la mise à jour du produit : $e');
  }
}


