import 'dart:convert';
import 'package:ap4_projet/server/api.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contrôleurs pour les champs de texte
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: emailController, // Contrôleur pour le champ de texte de l'username/email
              decoration: const InputDecoration(
                labelText: 'Username or email',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController, // Contrôleur pour le champ de texte du mot de passe
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String email = emailController.text;
                final String password = passwordController.text;

                try {
                  // Authentifier l'utilisateur
                  Map<String, dynamic> userData = await authenticateUser(email, password);
                  
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/main', arguments: userData);
                } catch (e) {
                  // Afficher un message d'erreur
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Rediriger vers une page pour modifier son mot de passe.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Modification du mot de passe en cours...'),
                  ),
                );
              },
              child: const Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}
