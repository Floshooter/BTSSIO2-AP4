import 'package:flutter/material.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<LogEntry> logs = [];

  void addRandomAction() {
    final randomAction = getRandomAction();
    setState(() {
      logs.add(randomAction);
    });
  }

  LogEntry getRandomAction() {
    // Générer un titre aléatoire pour l'action
    final titles = ['Connexion', 'Déconnexion', 'Modification du profil', 'Suppression d\'éléments', 'Erreur critique'];
    final randomTitle = titles[DateTime.now().microsecond % titles.length];

    // Générer une description aléatoire pour l'action
    const randomDescription = 'Description de l\'action aléatoire';

    // Générer un timestamp pour l'action
    final timestamp = DateTime.now().toString();
    final formattedTimestamp = timestamp.substring(0, 19);

    return LogEntry(title: randomTitle, description: randomDescription, timestamp: formattedTimestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Logs Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addRandomAction,
              child: const Text('Ajouter une action aléatoire'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return ListTile(
                    title: Text(log.title),
                    subtitle: Text(log.description),
                    trailing: Text(log.timestamp),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogEntry {
  final String title;
  final String description;
  final String timestamp;

  LogEntry({required this.title, required this.description, required this.timestamp});
}
