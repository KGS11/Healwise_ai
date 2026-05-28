class WellnessScoreCalculator {
  const WellnessScoreCalculator();

  double calculate({
    required double sleepScore,
    required double stressScore,
    required double activityScore,
    required double hydrationScore,
    required double consistencyScore,
  }) {
    return sleepScore * 0.25 +
        stressScore * 0.25 +
        activityScore * 0.20 +
        hydrationScore * 0.15 +
        consistencyScore * 0.15;
  }
}
