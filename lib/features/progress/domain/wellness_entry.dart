class WellnessEntry {
  const WellnessEntry({
    required this.id,
    required this.userId,
    required this.wellnessScore,
    required this.date,
    this.stressLevel,
    this.sleepHours,
    this.waterIntakeLiters,
    this.yogaMinutes,
  });

  final String id;
  final String userId;
  final double wellnessScore;
  final DateTime date;
  final double? stressLevel;
  final double? sleepHours;
  final double? waterIntakeLiters;
  final int? yogaMinutes;
}
