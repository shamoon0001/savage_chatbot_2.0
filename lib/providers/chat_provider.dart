// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../models/chat_message_model.dart';
import '../models/user_model.dart';
import './auth_provider.dart';

enum ChatFetchStatus { initial, loading, loaded, error }

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final AuthProvider _authProvider;

  List<ChatMessageModel> _messages = [];
  ChatFetchStatus _historyStatus = ChatFetchStatus.initial;
  bool _isSendingMessage = false;
  String? _errorMessage;

  ChatProvider(this._authProvider) {
    if (_authProvider.isAuthenticated) {
      fetchChatHistory();
    }
    _authProvider.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (_authProvider.isAuthenticated && _messages.isEmpty && _historyStatus != ChatFetchStatus.loading) {
      fetchChatHistory();
    } else if (!_authProvider.isAuthenticated) {
      _messages = [];
      _historyStatus = ChatFetchStatus.initial;
      _errorMessage = null;
      notifyListeners();
    }
  }

  List<ChatMessageModel> get messages => _messages;
  ChatFetchStatus get historyStatus => _historyStatus;
  bool get isSendingMessage => _isSendingMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChatHistory() async {
    if (!_authProvider.isAuthenticated || _authProvider.currentUser == null) {
      _errorMessage = "User not authenticated. Cannot fetch history.";
      _historyStatus = ChatFetchStatus.error;
      notifyListeners();
      return;
    }
    _historyStatus = ChatFetchStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _messages = await _chatService.getChatHistory();
      _historyStatus = ChatFetchStatus.loaded;
    } catch (e) {
      _errorMessage = "History Error: ${e.toString()}";
      _historyStatus = ChatFetchStatus.error;
      print(_errorMessage);
    }
    notifyListeners();
  }

  // Updated sendMessage to accept roastType
  Future<bool> sendMessage(String messageText, String roastType) async {
    if (!_authProvider.isAuthenticated || _authProvider.currentUser == null) {
      _errorMessage = "User not authenticated. Cannot send message.";
      notifyListeners();
      return false;
    }
    // messageText can be empty if user just clicks a roast type button

    _isSendingMessage = true;
    _errorMessage = null;
    notifyListeners();

    final User currentUser = _authProvider.currentUser!;
    // Add user's message optimistically only if they actually typed something.
    // If messageText is empty, it implies the user just clicked a roast type button,
    // and the "message" is implicitly "Roast me!" handled by the backend.
    ChatMessageModel? userMessage;
    if (messageText.isNotEmpty) {
      userMessage = ChatMessageModel(
        userId: currentUser.id,
        messageText: messageText,
        timestamp: DateTime.now(),
        senderType: SenderType.user,
      );
      _messages.add(userMessage);
      notifyListeners();
    }


    try {
      // Pass the original messageText (even if empty) and roastType
      final botReply = await _chatService.sendMessage(messageText, roastType);
      _messages.add(botReply);
      _isSendingMessage = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Send Error: ${e.toString()}";
      if (userMessage != null) {
        // _messages.remove(userMessage); // Optionally remove optimistic message on critical failure
      }
      _isSendingMessage = false;
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
