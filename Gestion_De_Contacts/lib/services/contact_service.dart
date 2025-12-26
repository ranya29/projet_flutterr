import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ContactService {
  static const String baseUrl = "http://10.0.2.2:8000";

  /// Ajouter un contact
  static Future<int> addContact(Contact contact) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/contacts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contact.toJson()),
      );

      final data = jsonDecode(response.body);
      debugPrint('✅ Contact ajouté: ${contact.name} (ID: ${data['id']})');
      return data['id'];
    } catch (e) {
      debugPrint('❌ Erreur ajout contact: $e');
      rethrow;
    }
  }

  /// Récupérer tous les contacts
  static Future<List<Contact>> getContacts() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/contacts'));

      final List data = jsonDecode(response.body);

      debugPrint('📋 ${data.length} contacts récupérés');
      return data.map((e) => Contact.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ Erreur récupération contacts: $e');
      return [];
    }
  }

  /// Récupérer un contact par ID
  static Future<Contact?> getContactById(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/contacts/$id'));

      if (response.statusCode == 200) {
        return Contact.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erreur récupération contact: $e');
      return null;
    }
  }

  /// Mettre à jour un contact
  static Future<int> updateContact(Contact contact) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/contacts/${contact.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contact.toJson()),
      );

      debugPrint('✅ Contact mis à jour: ${contact.name}');
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur mise à jour contact: $e');
      rethrow;
    }
  }

  /// Supprimer un contact
  static Future<int> deleteContact(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/contacts/$id'));

      debugPrint('🗑 Contact supprimé (ID: $id)');
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur suppression contact: $e');
      rethrow;
    }
  }

  /// Rechercher un contact
  static Future<List<Contact>> searchContacts(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contacts/search?query=$keyword'),
      );

      final List data = jsonDecode(response.body);

      debugPrint('🔍 ${data.length} contacts trouvés pour "$keyword"');
      return data.map((e) => Contact.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ Erreur recherche contacts: $e');
      return [];
    }
  }

  /// Mettre à jour le statut favori
  static Future<int> updateContactFavorite(int id, bool isFavorite) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/contacts/$id/favorite'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isFavorite': isFavorite}),
      );

      debugPrint('⭐ Favori mis à jour (ID: $id) -> $isFavorite');
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur mise à jour favori: $e');
      rethrow;
    }
  }

  /// Récupérer uniquement les favoris
  static Future<List<Contact>> getFavoriteContacts() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/contacts/favorites'));

      final List data = jsonDecode(response.body);

      debugPrint('⭐ ${data.length} contacts favoris');
      return data.map((e) => Contact.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ Erreur récupération favoris: $e');
      return [];
    }
  }

  /// Supprimer tous les contacts
  static Future<int> deleteAllContacts() async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/contacts'));

      debugPrint('🗑 Tous les contacts supprimés');
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur suppression tous contacts: $e');
      rethrow;
    }
  }
}
