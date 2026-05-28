class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
    this.safetyLevel = 'normal',
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;
  final String safetyLevel;
}
