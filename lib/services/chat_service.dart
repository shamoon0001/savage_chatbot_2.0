// lib/services/chat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/chat_message_model.dart';

class ChatService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AUTH_TOKEN_KEY);
    if (token == null) {
      throw Exception('Authentication token not found. Please log in.');
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };
  }

  // Updated sendMessage to include roastType
  Future<ChatMessageModel> sendMessage(String messageText, String roastType) async {
    try {
      final headers = await _getHeaders();
      final body = <String, String>{
        'message': messageText.isEmpty ? "Roast me!" : messageText, // Send default if empty
        'roast_type': roastType,
      };

      final response = await http.post(
        Uri.parse('$API_BASE_URL/chat/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return ChatMessageModel.fromJson(responseData);
      } else {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print('SendMessage Error: ${response.body}');
        throw Exception(responseData['error'] ?? 'Failed to send message. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('SendMessage Exception: $e');
      throw Exception('Error sending message: ${e.toString()}');
    }
  }

  Future<List<ChatMessageModel>> getChatHistory() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$API_BASE_URL/chat/history/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return responseData.map((json) => ChatMessageModel.fromJson(json)).toList();
      } else {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print('GetChatHistory Error: ${response.body}');
        throw Exception(responseData['error'] ?? 'Failed to load chat history. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('GetChatHistory Exception: $e');
      throw Exception('Error fetching chat history: ${e.toString()}');
    }
  }
}
