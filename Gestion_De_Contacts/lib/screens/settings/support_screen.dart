import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Aide & Support'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Besoin d\'aide ? Nous sommes là pour vous',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Divider(),

          // FAQ
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.purple),
            title: const Text('Questions fréquentes (FAQ)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigation vers FAQ page
              context.push('/faq'); // Crée une route /faq dans AppRouter
            },
          ),

          // Tutoriels
          ListTile(
            leading: const Icon(Icons.school, color: Colors.purple),
            title: const Text('Tutoriels'),
            subtitle: const Text('Apprenez à utiliser l\'application'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.push('/tutorials'); // Crée une route /tutorials
            },
          ),

          // Contacter le support
          ListTile(
            leading: const Icon(Icons.email, color: Colors.purple),
            title: const Text('Contacter le support'),
            subtitle: const Text('support@contactapp.com'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'support@contactapp.com',
                query: 'subject=Support%20ContactManager',
              );
              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              }
            },
          ),

          // Chat en direct
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.purple),
            title: const Text('Chat en direct'),
            subtitle: const Text('Disponible 24/7'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Rediriger vers une page chat ou intégration chat externe
              context.push('/live-chat'); 
            },
          ),

          // Signaler un bug
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.orange),
            title: const Text('Signaler un bug'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ReportBugDialog(),
              );
            },
          ),

          // Documentation
          ListTile(
            leading: const Icon(Icons.description, color: Colors.purple),
            title: const Text('Documentation'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              const url = 'https://example.com/documentation';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
          ),
        ],
      ),
    );
  }
}

// Dialogue signalement de bug
class ReportBugDialog extends StatefulWidget {
  const ReportBugDialog({super.key});

  @override
  State<ReportBugDialog> createState() => _ReportBugDialogState();
}

class _ReportBugDialogState extends State<ReportBugDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Signaler un bug'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Titre du problème',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description détaillée',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            // Ici tu peux envoyer le rapport au backend
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Rapport envoyé. Merci !'),
                backgroundColor: Colors.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          child: const Text('Envoyer', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
