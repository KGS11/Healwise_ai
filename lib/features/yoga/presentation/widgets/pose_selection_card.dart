import 'package:flutter/material.dart';

import '../../domain/pose_model.dart';

class PoseSelectionCard extends StatelessWidget {
  const PoseSelectionCard({
    super.key,
    required this.pose,
    required this.isSelected,
    required this.onTap,
  });

  final PoseModel pose;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SizedBox(
      width: 210,
      child: Card(
        elevation: isSelected ? 4 : 1,
        shadowColor: primaryColor.withValues(alpha: 0.14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? primaryColor : const Color(0xFFD8E2DD),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor.withValues(alpha: 0.12),
                      child: Icon(_iconFor(pose.emoji), color: primaryColor),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded, color: primaryColor),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  pose.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF12342F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pose.sanskritName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pose.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF647067),
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    _TinyChip(label: pose.difficulty),
                    const SizedBox(width: 6),
                    Expanded(child: _TinyChip(label: pose.duration)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String token) {
    return switch (token) {
      'mountain' => Icons.landscape_rounded,
      'warrior' => Icons.self_improvement_rounded,
      'shield' => Icons.security_rounded,
      'tree' => Icons.park_rounded,
      'leaf' => Icons.eco_rounded,
      'cobra' => Icons.waves_rounded,
      'dog' => Icons.change_history_rounded,
      'rest' => Icons.spa_rounded,
      _ => Icons.accessibility_new_rounded,
    };
  }
}

class _TinyChip extends StatelessWidget {
  const _TinyChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFF647067),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
