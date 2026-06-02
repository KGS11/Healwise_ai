import 'package:flutter/material.dart';

class AccuracyGauge extends StatelessWidget {
  const AccuracyGauge({
    super.key,
    required this.accuracy,
    required this.isCorrect,
  });

  final double accuracy;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final clampedAccuracy = accuracy.clamp(0, 100).toDouble();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: clampedAccuracy / 100),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: 168,
          height: 168,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 13,
                backgroundColor: const Color(0xFFE2E8E5),
                color: color,
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(value * 100).round()}%',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF12342F),
                          ),
                    ),
                    Text(
                      isCorrect ? 'Good form' : 'Needs work',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
