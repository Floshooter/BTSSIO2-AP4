import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Settings Page',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20), 
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
