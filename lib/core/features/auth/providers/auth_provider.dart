import 'package:flutter/material.dart';
import 'package:movewell/core/features/auth/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Role: 'patient' or 'doctor'
  String _userRole = 'patient';
  String get userRole => _userRole;

  void setRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final data = await _repository.login(email, password);
      // Example of handling backend token:
      final token = data['token']; 
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', _userRole);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false, error: e.toString());
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final responseData = await _repository.register(data);
      final token = responseData['token']; 
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', _userRole);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    _userRole = 'patient';
    notifyListeners();
  }

  /// Load the saved role from SharedPreferences (called from splash screen)
  Future<String> getSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    _userRole = prefs.getString('user_role') ?? 'patient';
    return _userRole;
  }

  void _setLoading(bool value, {String? error}) {
    _isLoading = value;
    _errorMessage = error;
    notifyListeners();
  }
}
