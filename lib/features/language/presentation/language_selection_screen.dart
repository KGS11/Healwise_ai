import 'package:flutter/material.dart';

import '../../auth/presentation/login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  void _openLogin(BuildContext context, String languageName) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(languageName: languageName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.health_and_safety_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'HealWise AI',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF10231F),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'AI-powered naturopathy, wellness guidance, and progress insights in your language.',
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const Spacer(),
              Text(
                'Choose your language',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openLogin(context, 'English'),
                icon: const Icon(Icons.language),
                label: const Text('Continue in English'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _openLogin(context, 'Kannada'),
                icon: const Icon(Icons.translate),
                label: const Text('Continue in Kannada'),
              ),
              const SizedBox(height: 24),
              Text(
                'This starter app is educational and not a medical diagnosis tool.',
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
