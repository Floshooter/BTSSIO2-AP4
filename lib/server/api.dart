import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> authenticateUser(String email, String password) async {
  String url = 'http://localhost:8001/users/login';

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> userData = jsonDecode(response.body);
    return userData;
  } else if (response.statusCode == 404) {
    throw Exception('Utilisateur non trouvé');
  } else {
    throw Exception('Mot de passe incorrect');
  }
}