// lib/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_message_model.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/loading_indicator.dart';
import '../auth/login_screen.dart';
import './chat_history_screen.dart';

// Custom PageRoute for slide-from-left animation
class SlideLeftRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  SlideLeftRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Start from the right
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut, // You can change the curve
          )),
          child: child,
        ),
    transitionDuration: const Duration(milliseconds: 300), // Adjust duration
  );
}


enum MoreOptions { logout }

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && (chatProvider.historyStatus == ChatFetchStatus.initial || chatProvider.messages.isEmpty)) {
        chatProvider.fetchChatHistory();
      }
      chatProvider.addListener(_scrollToBottomListener);
    });
  }

  void _onTextChanged() {
    if (!mounted) return;
    setState(() {
      _isTextFieldEmpty = _messageController.text.trim().isEmpty;
    });
  }

  void _scrollToBottomListener() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    try {
      Provider.of<ChatProvider>(context, listen: false).removeListener(_scrollToBottomListener);
    } catch (e) {
      // print("Error removing listener from ChatProvider: $e");
    }
    super.dispose();
  }

  void _sendMessage({required String roastType}) async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please type a message first."), backgroundColor: Colors.redAccent)
      );
      return;
    }

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    FocusScope.of(context).unfocus();

    bool success = await chatProvider.sendMessage(messageText, roastType);

    if (success) {
      _messageController.clear();
    }
  }

  void _handleMoreOptionSelection(MoreOptions selection) async {
    if (selection == MoreOptions.logout) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final currentUser = authProvider.currentUser;
    final theme = Theme.of(context);

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      });
      return const Scaffold(body: LoadingIndicator());
    }

    final bool canUseTopButtons = !chatProvider.isSendingMessage && !_isTextFieldEmpty;
    final bool showInlineSendButton = !_isTextFieldEmpty;
    final bool canUseInlineSendButton = showInlineSendButton && !chatProvider.isSendingMessage;


    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<MoreOptions>(
          onSelected: _handleMoreOptionSelection,
          icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MoreOptions>>[
            PopupMenuItem<MoreOptions>(
              value: MoreOptions.logout,
              child: Row(
                children: [
                  Icon(Icons.logout, color: theme.textTheme.bodyLarge?.color),
                  const SizedBox(width: 8),
                  const Text('Logout'),
                ],
              ),
            ),
          ],
        ),
        title: const Text('Chat with ShanaAI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: theme.colorScheme.primary),
            tooltip: 'View History',
            onPressed: () {
              // Use the custom slide route
              Navigator.of(context).push(
                SlideLeftRoute(page: const ChatHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.sentiment_very_satisfied, size: 18),
                  label: const Text('Humorous'),
                  onPressed: canUseTopButtons ? () => _sendMessage(roastType: 'humorous') : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    disabledBackgroundColor: Colors.grey[700],
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.sentiment_very_dissatisfied, size: 18),
                  label: const Text('Non-Humorous'),
                  onPressed: canUseTopButtons ? () => _sendMessage(roastType: 'non-humorous') : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    disabledBackgroundColor: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          if (chatProvider.errorMessage != null && chatProvider.historyStatus == ChatFetchStatus.error)
            Container(
              color: theme.colorScheme.error.withOpacity(0.8),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text(chatProvider.errorMessage!, style: TextStyle(color: theme.colorScheme.onError))),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onError),
                    onPressed: () => chatProvider.clearError(),
                  )
                ],
              ),
            ),

          Expanded(
            child: chatProvider.historyStatus == ChatFetchStatus.loading && chatProvider.messages.isEmpty
                ? const LoadingIndicator()
                : chatProvider.messages.isEmpty && chatProvider.historyStatus == ChatFetchStatus.loaded
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Type a message below and choose a roast style!',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: chatProvider.messages.length,
              itemBuilder: (ctx, index) {
                final message = chatProvider.messages[index];
                return MessageBubble(
                  message: message,
                  isMe: message.senderType == SenderType.user && message.userId == currentUser.id,
                );
              },
            ),
          ),

          if (chatProvider.isSendingMessage &&
              (chatProvider.messages.isEmpty ||
                  (chatProvider.messages.isNotEmpty && chatProvider.messages.last.senderType == SenderType.user))
          )
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0, top: 4.0),
              child: Row(
                children: [
                  Text("ShanaAI is typing...", style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                  const SizedBox(width: 8),
                  const SizedBox(height: 10, width: 10, child: LoadingIndicator(size: 10)),
                ],
              ),
            ),

          _buildMessageInputArea(context, theme, canUseInlineSendButton, showInlineSendButton),
        ],
      ),
    );
  }

  Widget _buildMessageInputArea(BuildContext context, ThemeData theme, bool canUseInlineSendButton, bool showInlineSendButton) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 4,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'Get roasted here...',
                hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.7)),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              ),
            ),
          ),
          if (showInlineSendButton)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: canUseInlineSendButton
                      ? () => _sendMessage(roastType: 'humorous')
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: canUseInlineSendButton ? theme.colorScheme.primary : Colors.grey[700],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color: theme.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
