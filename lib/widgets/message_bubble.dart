// lib/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/chat_message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe; // True if the message is from the current user

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isMe ? theme.colorScheme.primary.withOpacity(0.8) : theme.cardColor.withOpacity(0.9),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              )
            ]
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important for Column inside intrinsic width constraint
          children: [
            if (!isMe && message.senderType == SenderType.bot)
              Text(
                "ShanaAI", // Bot name
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.black87 : theme.colorScheme.secondary,
                  fontSize: 13,
                ),
              ),
            if (!isMe && message.senderType == SenderType.bot)
              const SizedBox(height: 3),
            SelectableText( // Makes text selectable
              message.messageText,
              style: TextStyle(
                color: isMe ? Colors.black : theme.textTheme.bodyLarge?.color,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp.toLocal()), // Format time
              style: TextStyle(
                color: isMe ? Colors.black.withOpacity(0.6) : theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
