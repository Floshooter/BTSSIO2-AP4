import 'package:flutter/material.dart';
import 'package:ap4_projet/server/api.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Paramètres',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Se déconnecter'),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Gérer mon compte'),
              onTap: () {
                // Afficher les informations de l'utilisateur dans une boîte de dialogue
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Informations du compte'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('ID: ${UserData.userDataConnected?['user']['userId']}'),
                          Text('Nom: ${UserData.userDataConnected?['user']['lastname']}'),
                          Text('Prénom: ${UserData.userDataConnected?['user']['firstname']}'),
                          Text('Nom d\'utilisateur: ${UserData.userDataConnected?['user']['username']}'),
                          Text('Email: ${UserData.userDataConnected?['user']['email']}'),
                          Text('Niveau de permission: ${UserData.userDataConnected?['user']['permLevel'] == 0 ? 'Utilisateur' : UserData.userDataConnected?['user']['perm_level'] == 1 ? 'Staff' : 'Administrateur'}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); 
                          },
                          child: const Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Langue'),
              onTap: () {
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Confidentialité'),
              onTap: () {
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Aide et support'),
              onTap: () {
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
