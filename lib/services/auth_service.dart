// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/user_model.dart'; // We might not directly use User model here but good to have

class AuthService {
  Future<Map<String, dynamic>> _getHeaders({bool includeToken = false}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8', // Ensure UTF-8 for special characters
    };
    if (includeToken) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AUTH_TOKEN_KEY);
      if (token != null) {
        headers['Authorization'] = 'Token $token';
      }
    }
    return headers;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/login/'),
        headers: await _getHeaders() as Map<String, String>,
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(utf8.decode(response.bodyBytes)); // Handle UTF-8

      if (response.statusCode == 200 && responseData['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AUTH_TOKEN_KEY, responseData['token']);
        await prefs.setInt(USER_ID_KEY, responseData['user_id']);
        await prefs.setString(USERNAME_KEY, responseData['username']);
        return {'success': true, 'token': responseData['token'], 'user_id': responseData['user_id'], 'username': responseData['username']};
      } else {
        return {'success': false, 'error': responseData['error'] ?? 'Login failed. Status: ${response.statusCode}'};
      }
    } catch (e) {
      print('Login Error: $e');
      return {'success': false, 'error': 'An error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> signup(String username, String password, {String? email}) async {
    try {
      final body = <String, String>{
        'username': username,
        'password': password,
      };
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }

      final response = await http.post(
        Uri.parse('$API_BASE_URL/signup/'),
        headers: await _getHeaders() as Map<String, String>,
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 201 && responseData['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AUTH_TOKEN_KEY, responseData['token']);
        await prefs.setInt(USER_ID_KEY, responseData['user_id']);
        await prefs.setString(USERNAME_KEY, responseData['username']);
        return {'success': true, 'token': responseData['token'], 'user_id': responseData['user_id'], 'username': responseData['username']};
      } else {
        return {'success': false, 'error': responseData['error'] ?? 'Signup failed. Status: ${response.statusCode}'};
      }
    } catch (e) {
      print('Signup Error: $e');
      return {'success': false, 'error': 'An error occurred: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AUTH_TOKEN_KEY);

      if (token != null) {
        // Call the backend logout endpoint
        await http.post(
          Uri.parse('$API_BASE_URL/logout/'),
          headers: await _getHeaders(includeToken: true) as Map<String, String>,
        );
        // Even if backend call fails, clear local token
      }
    } catch (e) {
      print('Backend logout error: $e');
      // Proceed to clear local data regardless of backend error
    } finally {
      // Always clear local storage on logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AUTH_TOKEN_KEY);
      await prefs.remove(USER_ID_KEY);
      await prefs.remove(USERNAME_KEY);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN_KEY);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    // Potentially add a token validation call to the backend here
    // For now, just checking if a token exists.
    return token != null;
  }

  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AUTH_TOKEN_KEY);
    if (token == null) return null;

    final userId = prefs.getInt(USER_ID_KEY);
    final username = prefs.getString(USERNAME_KEY);

    if (userId != null && username != null) {
      return {'user_id': userId, 'username': username, 'token': token};
    }
    return null;
  }
}
