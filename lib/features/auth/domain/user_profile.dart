class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.languageCode,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.healthHistory = const [],
    this.lifestyleHabits = const [],
  });

  final String id;
  final String name;
  final int age;
  final String languageCode;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final List<String> healthHistory;
  final List<String> lifestyleHabits;
}
