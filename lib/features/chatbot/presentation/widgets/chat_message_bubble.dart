import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  final String message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUser ? colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
              bottomLeft: Radius.circular(isUser ? 8 : 2),
              bottomRight: Radius.circular(isUser ? 2 : 8),
            ),
            border: isUser ? null : Border.all(color: const Color(0xFFE2E8E5)),
          ),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isUser ? Colors.white : const Color(0xFF10231F),
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}
