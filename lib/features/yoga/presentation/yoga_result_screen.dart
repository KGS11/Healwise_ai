import 'package:flutter/material.dart';

import '../domain/pose_analysis_response.dart';
import '../domain/pose_model.dart';
import 'widgets/accuracy_gauge.dart';
import 'widgets/body_parts_card.dart';
import 'widgets/feedback_card.dart';

class YogaResultScreen extends StatelessWidget {
  const YogaResultScreen({
    super.key,
    required this.result,
    required this.targetPose,
  });

  final PoseAnalysisResponse result;
  final PoseModel targetPose;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Pose Analysis Result'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  AccuracyGauge(
                    accuracy: result.accuracyPercent,
                    isCorrect: result.isCorrect,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    targetPose.displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF12342F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Detected: ${_formatPoseName(result.detectedPose)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _StatusPill(isCorrect: result.isCorrect),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FeedbackCard(
            feedbackText: result.feedbackText,
            isCorrect: result.isCorrect,
            processingTimeMs: result.processingTimeMs,
          ),
          const SizedBox(height: 12),
          BodyPartsCard(
            correctParts: result.keyPointsCorrect,
            incorrectParts: result.keyPointsIncorrect,
          ),
          const SizedBox(height: 12),
          _BenefitsCard(targetPose: targetPose),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.dashboard_outlined),
            label: const Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }

  String _formatPoseName(String value) {
    if (value.trim().isEmpty) {
      return 'Unknown';
    }
    return value
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isCorrect});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? const Color(0xFF16A34A) : const Color(0xFFEA580C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        isCorrect ? 'Correct posture' : 'Needs posture correction',
        style: TextStyle(color: color, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard({required this.targetPose});

  final PoseModel targetPose;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pose Benefits',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            ...targetPose.benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    const Icon(
                      Icons.spa_rounded,
                      size: 17,
                      color: Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(benefit)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
