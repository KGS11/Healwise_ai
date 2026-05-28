import 'package:flutter/material.dart';

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({
    super.key,
    required this.userName,
    required this.languageName,
  });

  final String userName;
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      userName.isEmpty ? 'H' : userName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    userName.isEmpty ? 'Wellness Friend' : userName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Profile, health history, lifestyle habits, and language preferences will be managed here.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645F),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Chip(label: Text('$languageName selected')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
