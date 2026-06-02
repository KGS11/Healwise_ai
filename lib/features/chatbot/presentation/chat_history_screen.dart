import 'package:flutter/material.dart';

import '../data/chat_repository.dart';
import '../domain/chat_session.dart';
import 'chatbot_screen.dart';
import 'widgets/chat_session_card.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({
    super.key,
    this.languageName = 'English',
    this.chatRepository,
  });

  final String languageName;
  final ChatRepository? chatRepository;

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  late final ChatRepository _chatRepository;

  @override
  void initState() {
    super.initState();
    _chatRepository = widget.chatRepository ?? ChatRepository();
  }

  Future<void> _openSession(ChatSession session) async {
    try {
      final messages = await _chatRepository.getMessages(session.sessionId);
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatbotScreen(
            languageName: widget.languageName,
            initialMessages: messages,
            initialSessionId: session.sessionId,
            readOnly: true,
          ),
        ),
      );
    } on ChatRepositoryException catch (e) {
      _showSnackBar(e.message);
    } catch (_) {
      _showSnackBar('Could not open this conversation.');
    }
  }

  Future<void> _confirmDeleteSession(ChatSession session) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this conversation?'),
        content: const Text('This will remove all messages in this chat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await _chatRepository.deleteSession(session.sessionId);
      if (!mounted) return;
      _showSnackBar('Conversation deleted.');
    } on ChatRepositoryException catch (e) {
      _showSnackBar(e.message);
    } catch (_) {
      _showSnackBar('Could not delete this conversation.');
    }
  }

  Future<void> _confirmClearHistory() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all chat history?'),
        content: const Text('This permanently deletes every saved chat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );

    if (shouldClear != true) {
      return;
    }

    try {
      await _chatRepository.clearAllHistory();
      if (!mounted) return;
      _showSnackBar('Chat history cleared.');
    } on ChatRepositoryException catch (e) {
      _showSnackBar(e.message);
    } catch (_) {
      _showSnackBar('Could not clear chat history.');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _confirmClearHistory,
          ),
        ],
      ),
      body: StreamBuilder<List<ChatSession>>(
        stream: _chatRepository.getSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _HistoryStateMessage(
              icon: Icons.error_outline_rounded,
              title: 'Could not load chat history',
              subtitle: 'Please check your connection and try again.',
              color: Colors.red.shade400,
            );
          }

          final sessions = snapshot.data ?? const <ChatSession>[];
          if (sessions.isEmpty) {
            return _HistoryStateMessage(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'No conversations yet',
              subtitle: 'Start a new chat to see history here',
              color: primaryColor,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return ChatSessionCard(
                session: session,
                onTap: () => _openSession(session),
                onDelete: () => _confirmDeleteSession(session),
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryStateMessage extends StatelessWidget {
  const _HistoryStateMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF12342F),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
