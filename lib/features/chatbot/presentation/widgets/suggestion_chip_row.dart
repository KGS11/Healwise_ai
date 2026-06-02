import 'package:flutter/material.dart';

class SuggestionChipRow extends StatelessWidget {
  const SuggestionChipRow({
    super.key,
    required this.onTapSuggestion,
  });

  final ValueChanged<String> onTapSuggestion;

  static const List<Map<String, String>> _suggestions = [
    {
      'label': '😴 Better Sleep',
      'query': 'improve sleep',
    },
    {
      'label': '🥗 Healthy Diet',
      'query': 'healthy diet',
    },
    {
      'label': '🧘 Yoga Tips',
      'query': 'yoga',
    },
    {
      'label': '😌 Stress Relief',
      'query': 'stress reduction',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          final label = suggestion['label']!;
          final query = suggestion['query']!;

          return ActionChip(
            label: Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            backgroundColor: Colors.white,
            side: BorderSide(color: primaryColor.withValues(alpha: 0.5), width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            onPressed: () => onTapSuggestion(query),
          );
        },
      ),
    );
  }
}
