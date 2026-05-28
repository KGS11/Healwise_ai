class MedicalReport {
  const MedicalReport({
    required this.id,
    required this.userId,
    required this.extractedText,
    required this.createdAt,
    this.fileUrl,
    this.parameters = const {},
    this.explanation,
  });

  final String id;
  final String userId;
  final String? fileUrl;
  final String extractedText;
  final Map<String, Object?> parameters;
  final String? explanation;
  final DateTime createdAt;
}
