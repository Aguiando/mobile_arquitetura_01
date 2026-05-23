import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
 
/// Mantém o usuário autenticado em memória e persiste em SharedPreferences.
class SessionController extends ChangeNotifier {
  static final SessionController instance = SessionController._();
  SessionController._();
 
  User? _user;
  User? get currentUser => _user;
  bool get isLoggedIn => _user != null;
  String? get token => _user?.token;
 
  static const _key = 'session_user';
 
  /// Carrega sessão persistida ao iniciar o app.
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      try {
        _user = User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        notifyListeners();
      } catch (_) {
        await prefs.remove(_key);
      }
    }
  }
 
  Future<void> login(User user) async {
    _user = user;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
  }
 
  Future<void> logout() async {
    _user = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}