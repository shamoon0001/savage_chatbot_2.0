// lib/screens/chat/chat_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart'; // To get current user for MessageBubble
import '../../widgets/message_bubble.dart';
import '../../models/chat_message_model.dart'; // For SenderType
import '../../widgets/loading_indicator.dart';

class ChatHistoryScreen extends StatelessWidget {
  static const routeName = '/chat-history';

  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    // We need authProvider to determine 'isMe' for MessageBubble
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    final theme = Theme.of(context);

    // If there's no current user, something is wrong.
    // This screen should only be accessible if the user is logged in.
    if (currentUser == null) {
      // Navigate back or show an error, though routing should prevent this.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("User not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        centerTitle: true,
        leading: IconButton( // Add a back button
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          if (chatProvider.historyStatus == ChatFetchStatus.loading && chatProvider.messages.isEmpty)
            const Expanded(child: LoadingIndicator())
          else if (chatProvider.messages.isEmpty && chatProvider.historyStatus == ChatFetchStatus.loaded)
            Expanded(
              child: Center(
                child: Text(
                  'No history found.',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            )
          else if (chatProvider.historyStatus == ChatFetchStatus.error)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error loading history: ${chatProvider.errorMessage ?? 'Unknown error'}",
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (ctx, index) {
                    final message = chatProvider.messages[index];
                    return MessageBubble(
                      message: message,
                      // Ensure SenderType is accessible here
                      isMe: message.senderType == SenderType.user && message.userId == currentUser.id,
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
