import 'package:flutter/material.dart';

class BodyPartsCard extends StatelessWidget {
  const BodyPartsCard({
    super.key,
    required this.correctParts,
    required this.incorrectParts,
  });

  final List<String> correctParts;
  final List<String> incorrectParts;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Body Part Analysis',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            _PartsSection(
              title: 'Correct',
              parts: correctParts,
              color: const Color(0xFF16A34A),
              icon: Icons.check_circle_outline_rounded,
              emptyText: 'No correct key points detected yet.',
            ),
            const SizedBox(height: 14),
            _PartsSection(
              title: 'Needs Improvement',
              parts: incorrectParts,
              color: const Color(0xFFDC2626),
              icon: Icons.error_outline_rounded,
              emptyText: 'No major issues detected.',
            ),
          ],
        ),
      ),
    );
  }
}

class _PartsSection extends StatelessWidget {
  const _PartsSection({
    required this.title,
    required this.parts,
    required this.color,
    required this.icon,
    required this.emptyText,
  });

  final String title;
  final List<String> parts;
  final Color color;
  final IconData icon;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (parts.isEmpty)
          Text(
            emptyText,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF647067)),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: parts.map((part) {
              return Chip(
                label: Text(_labelFor(part)),
                backgroundColor: color.withValues(alpha: 0.1),
                side: BorderSide(color: color.withValues(alpha: 0.25)),
                labelStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  String _labelFor(String raw) {
    return raw
        .replaceAll('_angle', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
