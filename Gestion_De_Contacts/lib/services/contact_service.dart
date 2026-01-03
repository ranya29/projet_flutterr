import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/contact.dart';
import 'auth_service.dart';

class ContactService {
  static const String baseUrl = "http://10.0.2.2:8000";

  /// 🔑 Récupérer l'ID de l'utilisateur connecté
  static Future<int?> _getCurrentUserId() async {
    final user = await AuthService.getCurrentUser();
    return user?.id;
  }

  /// Ajouter un contact
  static Future<int> addContact(Contact contact) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // ✅ Assigner le user_id au contact
      contact.userId = userId;
      final contactData = contact.toJson();

      debugPrint('📤 Envoi ajout: $contactData');

      final response = await http.post(
        Uri.parse('$baseUrl/contacts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contactData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Contact ajouté: ${contact.name} (ID: ${data['id']})');
        return data['id'];
      } else {
        final error = jsonDecode(response.body);
        debugPrint('❌ Erreur ${response.statusCode}: ${error['detail']}');
        throw Exception(error['detail']);
      }
    } catch (e) {
      debugPrint('❌ Erreur ajout contact: $e');
      rethrow;
    }
  }

  /// Récupérer tous les contacts de l'utilisateur connecté
  static Future<List<Contact>> getContacts() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        debugPrint('⚠️ Aucun utilisateur connecté');
        return [];
      }

      // ✅ Filtrer par user_id
      final response = await http.get(
        Uri.parse('$baseUrl/contacts?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        debugPrint('📋 ${data.length} contacts récupérés pour user $userId');
        return data.map((e) => Contact.fromJson(e)).toList();
      } else {
        debugPrint('❌ Erreur: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération contacts: $e');
      return [];
    }
  }

  /// Récupérer un contact par ID
  static Future<Contact?> getContactById(int id) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/contacts/$id?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final contactData = jsonDecode(response.body);
        
        // ✅ Vérifier que le contact appartient bien à l'utilisateur
        if (contactData['user_id'] == userId) {
          return Contact.fromJson(contactData);
        } else {
          debugPrint('❌ Ce contact ne vous appartient pas');
          return null;
        }
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
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // ✅ Assigner le user_id
      contact.userId = userId;
      final contactData = contact.toJson();
      
      debugPrint('📤 Envoi mise à jour: $contactData');

      final response = await http.put(
        Uri.parse('$baseUrl/contacts/${contact.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contactData),
      );

      if (response.statusCode == 200) {
        final updatedData = jsonDecode(response.body);
        debugPrint('✅ Contact mis à jour: ${updatedData['name']} - Phone: ${updatedData['phone']}');
      } else {
        final error = jsonDecode(response.body);
        debugPrint('❌ Erreur ${response.statusCode}: ${error['detail']}');
      }
      
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur mise à jour contact: $e');
      rethrow;
    }
  }

  /// Supprimer un contact
  static Future<int> deleteContact(int id) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/contacts/$id?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        debugPrint('🗑 Contact supprimé (ID: $id)');
      }
      
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur suppression contact: $e');
      rethrow;
    }
  }

  /// Rechercher un contact
  static Future<List<Contact>> searchContacts(String keyword) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/contacts/search?query=$keyword&user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        debugPrint('🔍 ${data.length} contacts trouvés pour "$keyword"');
        return data.map((e) => Contact.fromJson(e)).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ Erreur recherche contacts: $e');
      return [];
    }
  }

  /// Mettre à jour le statut favori
  static Future<int> updateContactFavorite(int id, bool isFavorite) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/contacts/$id/favorite?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isFavorite': isFavorite}),
      );

      if (response.statusCode == 200) {
        debugPrint('⭐ Favori mis à jour (ID: $id) -> $isFavorite');
      }
      
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur mise à jour favori: $e');
      rethrow;
    }
  }

  /// Récupérer uniquement les favoris
  static Future<List<Contact>> getFavoriteContacts() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/contacts/favorites?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        debugPrint('⭐ ${data.length} contacts favoris');
        return data.map((e) => Contact.fromJson(e)).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ Erreur récupération favoris: $e');
      return [];
    }
  }

  /// Supprimer tous les contacts de l'utilisateur
  static Future<int> deleteAllContacts() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/contacts?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        debugPrint('🗑 Tous vos contacts supprimés');
      }
      
      return response.statusCode;
    } catch (e) {
      debugPrint('❌ Erreur suppression tous contacts: $e');
      rethrow;
    }
  }
}