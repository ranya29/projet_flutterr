import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('À propos'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Logo de l'app
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.contacts,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Nom de l'app
          const Center(
            child: Text(
              'Contact Manager',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          // Version
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),

          // Description
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'À propos de l\'application',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Contact Manager est une application moderne et intuitive '
                    'pour gérer vos contacts de manière efficace. '
                    'Organisez, recherchez et gardez le contact facilement.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Développeur
          const Card(
            child: ListTile(
              leading: Icon(Icons.code, color: Colors.purple),
              title: Text('Développé par'),
              subtitle: Text('Hadda Nihal - Mathlouthi Ranya'),
            ),
          ),

          // Licence
          Card(
            child: ListTile(
              leading: const Icon(Icons.gavel, color: Colors.purple),
              title: const Text('Licence'),
              subtitle: const Text('MIT License'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: afficher la licence
              },
            ),
          ),

          // Conditions d'utilisation
          Card(
            child: ListTile(
              leading: const Icon(Icons.description, color: Colors.purple),
              title: const Text('Conditions d\'utilisation'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: afficher les conditions
              },
            ),
          ),

          // Politique de confidentialité
          Card(
            child: ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.purple),
              title: const Text('Politique de confidentialité'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: afficher la politique
              },
            ),
          ),

          const SizedBox(height: 30),

          // Copyright
          const Center(
            child: Text(
              '© 2024 Contact Manager. Tous droits réservés.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
