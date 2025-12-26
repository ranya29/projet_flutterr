import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database.dart';
import '../models/user.dart';

class AuthService {
  // -----------------------------------------------------------
  // 🔐 Enregistrer un utilisateur (inscription)
  // -----------------------------------------------------------
  static Future<int> register(User user) async {
    try {
      final db = await AppDatabase.database;
      debugPrint('📝 Tentative inscription pour: ${user.email}');
      
      final result = await db.insert('users', user.toMap());
      
      debugPrint('✅ Inscription réussie, ID: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Erreur inscription: $e');
      rethrow;
    }
  }

  // -----------------------------------------------------------
  // 🔐 Connexion
  // -----------------------------------------------------------
  static Future<User?> login(String email, String password) async {
    try {
      final db = await AppDatabase.database;
      debugPrint('🔐 Tentative connexion pour: $email');

      final res = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (res.isNotEmpty) {
        final user = User.fromMap(res.first);
        debugPrint('✅ Connexion réussie pour: $email');

        // Stocker la session
        await saveCurrentUser(user.id!);

        return user;
      } else {
        debugPrint('❌ Échec connexion pour: $email');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Erreur connexion: $e');
      rethrow;
    }
  }

  // -----------------------------------------------------------
  // 📌 Vérifier si un email existe déjà
  // -----------------------------------------------------------
  static Future<bool> emailExists(String email) async {
    try {
      final db = await AppDatabase.database;
      final res = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      return res.isNotEmpty;
    } catch (e) {
      debugPrint('❌ Erreur vérification email: $e');
      rethrow;
    }
  }

  // -----------------------------------------------------------
  // 🔐 Sauvegarder l'utilisateur courant
  // -----------------------------------------------------------
  static Future<void> saveCurrentUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("current_user_id", userId);
  }

  // -----------------------------------------------------------
  // 👤 Récupérer l'utilisateur connecté
  // -----------------------------------------------------------
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("current_user_id");

    if (id == null) return null;

    final db = await AppDatabase.database;
    final res = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  // -----------------------------------------------------------
  // 🚪 Déconnexion
  // -----------------------------------------------------------
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("current_user_id");
  }
}