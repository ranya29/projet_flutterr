import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/contact.dart';
import '../../services/contact_service.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  bool loading = true;

  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  // Charger les contacts (normal ou recherche)
  void fetchContacts() async {
    if (searchQuery.isEmpty) {
      contacts = await ContactService.getContacts();
    } else {
      contacts = await ContactService.searchContacts(searchQuery);
    }

    setState(() {
      loading = false;
    });
  }

  // Supprimer
  void deleteContact(int id) async {
    await ContactService.deleteContact(id);
    fetchContacts();
  }

  // Favoris
  void toggleFavorite(Contact contact) async {
    final newStatus = !contact.isFavorite;
    await ContactService.updateContactFavorite(contact.id!, newStatus);
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ✅ AJOUT DE LA FLÈCHE DE RETOUR
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home'); // Retour à la page d'accueil
          },
        ),
        title: const Text('Mes Contacts'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/add-contact');
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔍 Champ de recherche
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un contact...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                searchQuery = value;
                fetchContacts();
              },
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : contacts.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun contact trouvé',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: contact.photo != null
                                    ? FileImage(File(contact.photo!))
                                    : null,
                                child: contact.photo == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),

                              title: Text(
                                contact.name,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),

                              subtitle: Text(contact.phone),

                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      contact.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => toggleFavorite(contact),
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.orange),
                                    onPressed: () {
                                      context.go('/edit-contact',
                                          extra: contact);
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        deleteContact(contact.id!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}