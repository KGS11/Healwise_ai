class PoseModel {
  const PoseModel({
    required this.id,
    required this.displayName,
    required this.sanskritName,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.emoji,
    required this.benefits,
  });

  final String id;
  final String displayName;
  final String sanskritName;
  final String description;
  final String difficulty;
  final String duration;
  final String emoji;
  final List<String> benefits;
}
