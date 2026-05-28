class YogaSession {
  const YogaSession({
    required this.id,
    required this.userId,
    required this.poseName,
    required this.durationSeconds,
    required this.accuracyPercent,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String poseName;
  final int durationSeconds;
  final double accuracyPercent;
  final DateTime createdAt;
}
