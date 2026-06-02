import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.isTyping,
    this.messageId,
    this.sessionId,
  });

  final String id; // unique message id
  final String text; // message content
  final bool isUser; // true = user, false = AI
  final DateTime timestamp; // when sent
  final bool isTyping; // true = show typing indicator
  final String? messageId; // Firestore document ID
  final String? sessionId; // parent session ID

  // Builds a ChatMessage from a Firestore message document.
  factory ChatMessage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final timestamp = data['timestamp'];

    return ChatMessage(
      id: (data['messageId'] as String?) ?? doc.id,
      messageId: (data['messageId'] as String?) ?? doc.id,
      sessionId: data['sessionId'] as String?,
      text: (data['text'] as String?) ?? '',
      isUser: (data['isUser'] as bool?) ?? false,
      timestamp: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
      isTyping: false,
    );
  }

  // Converts a chat message into Firestore-safe data.
  Map<String, dynamic> toMap() {
    final firestoreMessageId = messageId ?? id;

    return {
      'messageId': firestoreMessageId,
      'sessionId': sessionId,
      'text': text,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isTyping,
    String? messageId,
    String? sessionId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
      messageId: messageId ?? this.messageId,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}
