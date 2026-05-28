import 'package:flutter/material.dart';

class ChatbotPlaceholderScreen extends StatelessWidget {
  const ChatbotPlaceholderScreen({super.key, required this.languageName});

  final String languageName;

  @override
  Widget build(BuildContext context) {
    return _PlaceholderView(
      icon: Icons.chat_bubble_outline,
      title: 'AI Chatbot',
      subtitle:
          'Symptom guidance, natural therapy suggestions, and safety warnings will be built here.',
      languageName: languageName,
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.languageName,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String languageName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: colorScheme.primary, size: 36),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645F),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Chip(label: Text('$languageName ready')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
