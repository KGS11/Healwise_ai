import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSession {
  const ChatSession({
    required this.sessionId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
  });

  final String sessionId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;

  // Builds a ChatSession from a Firestore session document.
  factory ChatSession.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];

    return ChatSession(
      sessionId: (data['sessionId'] as String?) ?? doc.id,
      title: (data['title'] as String?) ?? 'Untitled chat',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      updatedAt: updatedAt is Timestamp ? updatedAt.toDate() : DateTime.now(),
      messageCount: (data['messageCount'] as num?)?.toInt() ?? 0,
    );
  }

  // Converts this session into Firestore-safe data.
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'messageCount': messageCount,
    };
  }

  ChatSession copyWith({
    String? sessionId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
  }) {
    return ChatSession(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}
