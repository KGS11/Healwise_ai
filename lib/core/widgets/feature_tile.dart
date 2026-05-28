import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: colorScheme.primary),
                  ),
                  const Spacer(),
                  Text(
                    status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF647067),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
