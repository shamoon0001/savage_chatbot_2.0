// lib/models/chat_message_model.dart

enum SenderType { user, bot }

class ChatMessageModel {
  final int? id; // Can be null if it's a new message not yet saved to backend
  final int userId;
  final String messageText;
  final DateTime timestamp;
  final SenderType senderType;

  ChatMessageModel({
    this.id,
    required this.userId,
    required this.messageText,
    required this.timestamp,
    required this.senderType,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      userId: json['user'], // Assuming backend sends 'user' as user_id
      messageText: json['message_text'],
      timestamp: DateTime.parse(json['timestamp']),
      senderType: json['sender_type'] == 'bot' ? SenderType.bot : SenderType.user,
    );
  }

  Map<String, dynamic> toJson() {
    // This is mainly for sending a new message to the backend
    return {
      // 'id': id, // Not sent when creating a new message
      // 'user': userId, // Backend will associate with authenticated user
      'message': messageText, // Backend expects 'message' for user input
      // 'timestamp': timestamp.toIso8601String(), // Backend sets timestamp
      // 'sender_type': senderType == SenderType.bot ? 'bot' : 'user', // Backend determines this
    };
  }
}
