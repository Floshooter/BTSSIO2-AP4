import 'package:ap4_projet/server/api.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contrôleurs pour les champs de texte
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Fonction pour se connecter avec un compte spécifique
    void loginWithAccount(String email, String password) async {
      try {
        // Authentifier l'utilisateur
        Map<String, dynamic> userData = await authenticateUser(email, password);

        Map<String, dynamic> user = userData['user'] ?? {};
        
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(
          context,
          '/',
          arguments: user, 
        );
      } catch (e) {
        // Afficher un message d'erreur
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController, // Contrôleur pour le champ de texte du mot de passe
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String email = emailController.text;
                final String password = passwordController.text;
                // Appeler la fonction de connexion avec les données entrées
                loginWithAccount(email, password);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            // Boutons pour la connexion avec des comptes spécifiques
            ElevatedButton(
              onPressed: () {
                // Se connecter avec le premier compte
                loginWithAccount('a.lemercier@m2l.fr', 'angela@staff');
              },
              child: const Text('Staff'),
            ),
            ElevatedButton(
              onPressed: () {
                // Se connecter avec le premier compte
                loginWithAccount('davidgroove@gmail.com', 'davidgroove64');
              },
              child: const Text('Utilisateur'),
            ),
            TextButton(
              onPressed: () {
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