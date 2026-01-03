import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool smsNotifications = false;
  bool newContactNotif = true;
  bool favoriteNotif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Gérer vos préférences de notifications',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),

          const Divider(),

          /// Notifications générales
          SwitchListTile(
            title: const Text('Notifications Push'),
            subtitle:
                const Text('Recevoir des notifications sur l\'appareil'),
            value: pushNotifications,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.notifications_active),
            onChanged: (value) {
              setState(() {
                pushNotifications = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Notifications par Email'),
            subtitle: const Text('Recevoir des emails'),
            value: emailNotifications,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.email),
            onChanged: (value) {
              setState(() {
                emailNotifications = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Notifications SMS'),
            subtitle: const Text('Recevoir des SMS'),
            value: smsNotifications,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.sms),
            onChanged: (value) {
              setState(() {
                smsNotifications = value;
              });
            },
          ),

          const Divider(),

          /// Types de notifications
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Types de notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          SwitchListTile(
            title: const Text('Nouveau contact ajouté'),
            value: newContactNotif,
            activeColor: Colors.purple,
            onChanged: pushNotifications
                ? (value) {
                    setState(() {
                      newContactNotif = value;
                    });
                  }
                : null,
          ),

          SwitchListTile(
            title: const Text('Contacts favoris modifiés'),
            value: favoriteNotif,
            activeColor: Colors.purple,
            onChanged: pushNotifications
                ? (value) {
                    setState(() {
                      favoriteNotif = value;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
