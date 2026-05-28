import 'package:flutter/material.dart';

class ProgressPlaceholderScreen extends StatelessWidget {
  const ProgressPlaceholderScreen({super.key, required this.languageName});

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
                  Icon(Icons.show_chart, color: colorScheme.primary, size: 36),
                  const SizedBox(height: 14),
                  Text(
                    'Progress Tracker',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wellness score, sleep, stress, yoga streaks, and health trends will appear here.',
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
