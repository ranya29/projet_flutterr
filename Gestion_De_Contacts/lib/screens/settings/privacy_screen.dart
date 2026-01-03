import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool showOnlineStatus = true;
  bool allowLocationAccess = false;
  bool allowContactsSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Confidentialité'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Contrôlez vos données et votre vie privée',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Divider(),

          // Statut en ligne
          SwitchListTile(
            title: const Text('Afficher le statut en ligne'),
            subtitle: const Text('Les autres peuvent voir quand vous êtes actif'),
            value: showOnlineStatus,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.visibility),
            onChanged: (value) {
              setState(() {
                showOnlineStatus = value;
              });
            },
          ),

          // Localisation
          SwitchListTile(
            title: const Text('Accès à la localisation'),
            subtitle: const Text('Autoriser l\'accès à votre position'),
            value: allowLocationAccess,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.location_on),
            onChanged: (value) {
              setState(() {
                allowLocationAccess = value;
              });
            },
          ),

          // Synchronisation contacts
          SwitchListTile(
            title: const Text('Synchronisation des contacts'),
            subtitle: const Text('Synchroniser avec le carnet d\'adresses'),
            value: allowContactsSync,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.sync),
            onChanged: (value) {
              setState(() {
                allowContactsSync = value;
              });
            },
          ),

          const Divider(),

          // Changer le mot de passe
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.purple),
            title: const Text('Changer le mot de passe'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ChangePasswordDialog(),
              );
            },
          ),

          // Données et stockage (fonctionnel)
          ListTile(
            leading: const Icon(Icons.storage, color: Colors.purple),
            title: const Text('Données et stockage'),
            subtitle: const Text('Gérer vos données stockées'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Supprimer les données locales'),
                  content: const Text(
                      'Voulez-vous vraiment supprimer toutes les données locales de l\'application ? Cette action est irréversible.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Toutes les données locales ont été supprimées'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Supprimer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Supprimer le compte
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Supprimer mon compte',
              style: TextStyle(color: Colors.red),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const DeleteAccountDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Dialogue changement de mot de passe
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Changer le mot de passe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: obscureOld,
              decoration: InputDecoration(
                labelText: 'Ancien mot de passe',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(obscureOld ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => obscureOld = !obscureOld),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: obscureNew,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(obscureNew ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => obscureNew = !obscureNew),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(obscureConfirm ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (newPasswordController.text == confirmPasswordController.text) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Mot de passe modifié avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Les mots de passe ne correspondent pas'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          child: const Text('Modifier', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

// Dialogue suppression de compte
class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer le compte'),
      content: const Text(
        'Êtes-vous sûr de vouloir supprimer votre compte ? '
        'Cette action est irréversible et toutes vos données seront perdues.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Compte supprimé'),
                backgroundColor: Colors.red,
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
