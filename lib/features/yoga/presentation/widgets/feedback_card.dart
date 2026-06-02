import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
    required this.feedbackText,
    required this.isCorrect,
    required this.processingTimeMs,
  });

  final String feedbackText;
  final bool isCorrect;
  final double processingTimeMs;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? const Color(0xFF16A34A) : const Color(0xFFEA580C);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(
                isCorrect
                    ? Icons.check_rounded
                    : Icons.tips_and_updates_rounded,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCorrect
                        ? 'Correction Feedback'
                        : 'Improvement Suggestion',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    feedbackText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645F),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Processed in ${processingTimeMs.toStringAsFixed(1)} ms',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF647067),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
