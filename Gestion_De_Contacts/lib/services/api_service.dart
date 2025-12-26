import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  // Pour Windows Desktop
  static const String baseUrl = 'http://localhost:8000';
  
  // Pour émulateur Android, décommentez cette ligne :
  // static const String baseUrl = 'http://10.0.2.2:8000';

  // ======================
  // GET : récupérer tous les contacts
  // ======================
  static Future<List<Contact>> getContacts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/contacts'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Contact.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des contacts');
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  // ======================
  // POST : ajouter un contact
  // ======================
  static Future<String> addContact(Contact contact) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/contacts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(contact.toJson()),
      );

      if (response.statusCode == 200) {
        return 'Contact ajouté avec succès';
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Erreur lors de l\'ajout');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // ======================
  // DELETE : supprimer un contact
  // ======================
  static Future<String> deleteContact(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/contacts/$id'),
      );

      if (response.statusCode == 200) {
        return 'Contact supprimé avec succès';
      } else {
        throw Exception('Erreur lors de la suppression');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}