import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackactive/models/user.dart';
import 'package:trackactive/services/db_helper.dart';

class AuthService {
  final dbHelper = DBHelper.instance;
  final Logger logger = Logger();

  int? _userId;

  Future<void> registerUser(String email, String password) async {
    final hashedPassword = _hashPassword(password);
    final user = UserModel(email: email, password: hashedPassword);

    try {
      await dbHelper.insertUser(user);
    } catch (e) {
      logger.e("Error during registration: $e");
    }
  }

  Future<bool> loginUser(String email, String password) async {
    final hashedPassword = _hashPassword(password);
    final user = await dbHelper.getUserByEmail(email);

    if (user != null && user.password == hashedPassword) {
      // On successful login, save the login state and user ID
      if (user.id != null) {
        // Ensure user.id is not null
        // _userId = user.id!; // Use null check operator to get the value safely
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Save login state
        // await prefs.setInt(
        //     'userId', user.id!); // Save user ID (ensure it's not null)
        return true;
      }
    }
    return false;
  }

  int? get userId => _userId;

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId'); // Clear the stored user ID
  }
}
