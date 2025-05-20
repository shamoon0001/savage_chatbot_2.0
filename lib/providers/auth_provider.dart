// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart'; // For storing current user details

enum AuthStatus { uninitialized, authenticated, authenticating, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.uninitialized;
  String? _token;
  User? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get token => _token;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _token != null;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      final userDetails = await _authService.getCurrentUserDetails();
      if (userDetails != null && userDetails['token'] != null) {
        _token = userDetails['token'];
        _currentUser = User(id: userDetails['user_id'], username: userDetails['username']);
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = "Initialization failed: ${e.toString()}";
      print("Auth Init Error: $_errorMessage");
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(username, password);
      if (response['success'] == true && response['token'] != null) {
        _token = response['token'];
        _currentUser = User(id: response['user_id'], username: response['username']);
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['error'] ?? 'Login failed.';
        _status = AuthStatus.unauthenticated; // Or AuthStatus.error
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Login Error: ${e.toString()}";
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String username, String password, {String? email}) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signup(username, password, email: email);
      if (response['success'] == true && response['token'] != null) {
        _token = response['token'];
        _currentUser = User(id: response['user_id'], username: response['username']);
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['error'] ?? 'Signup failed.';
        _status = AuthStatus.unauthenticated; // Or AuthStatus.error
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Signup Error: ${e.toString()}";
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    // _status = AuthStatus.authenticating; // Optional: show loading state during logout
    // notifyListeners();
    try {
      await _authService.logout();
    } catch(e) {
      // Log error but proceed with local logout
      print("Error during backend logout: $e");
    } finally {
      _token = null;
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    // Optionally reset status if it was error
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated; // Or back to uninitialized if makes sense
    }
    notifyListeners();
  }
}
