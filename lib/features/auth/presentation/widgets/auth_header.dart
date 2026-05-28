import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.languageName,
  });

  final String title;
  final String subtitle;
  final String languageName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.health_and_safety_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            const Spacer(),
            Chip(
              avatar: const Icon(Icons.translate, size: 16),
              label: Text(languageName),
              side: const BorderSide(color: Color(0xFFD7E3DD)),
              backgroundColor: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF10231F),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF53645F),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
