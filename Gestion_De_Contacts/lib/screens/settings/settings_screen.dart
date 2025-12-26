import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingCard(
            icon: Icons.account_circle,
            title: "Profil",
            onTap: () => _showComingSoon(context, "Profil"),
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () => _showComingSoon(context, "Notifications"),
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.security,
            title: "Confidentialité",
            onTap: () => _showComingSoon(context, "Confidentialité"),
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.color_lens,
            title: "Thème",
            onTap: () => _showComingSoon(context, "Thème"),
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.help,
            title: "Aide & Support",
            onTap: () => _showComingSoon(context, "Aide"),
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.info,
            title: "À propos",
            onTap: () => _showAbout(context),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Se déconnecter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature - Bientôt disponible")),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Mes Contacts",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(
        Icons.contacts,
        color: Colors.purple,
        size: 50,
      ),
      children: const [
        SizedBox(height: 10),
        Text("Application de gestion de contacts"),
        SizedBox(height: 10),
        Text("Développée avec Flutter & SQLite"),
        SizedBox(height: 10),
        Text("© 2025 - Tous droits réservés"),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }
}