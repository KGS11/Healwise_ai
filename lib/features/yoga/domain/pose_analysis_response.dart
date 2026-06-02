class LandmarkPoint {
  const LandmarkPoint({
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  final double x;
  final double y;
  final double z;
  final double visibility;

  factory LandmarkPoint.fromJson(Map<String, dynamic> json) {
    return LandmarkPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
    );
  }
}

class PoseAnalysisResponse {
  const PoseAnalysisResponse({
    required this.success,
    required this.detectedPose,
    required this.targetPose,
    required this.accuracyPercent,
    required this.isCorrect,
    required this.landmarks,
    required this.feedbackText,
    required this.feedbackColor,
    required this.keyPointsCorrect,
    required this.keyPointsIncorrect,
    required this.processingTimeMs,
  });

  final bool success;
  final String detectedPose;
  final String targetPose;
  final double accuracyPercent;
  final bool isCorrect;
  final List<LandmarkPoint> landmarks;
  final String feedbackText;
  final String feedbackColor;
  final List<String> keyPointsCorrect;
  final List<String> keyPointsIncorrect;
  final double processingTimeMs;

  factory PoseAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return PoseAnalysisResponse(
      success: json['success'] as bool? ?? false,
      detectedPose: json['detectedPose'] as String? ?? 'unknown',
      targetPose: json['targetPose'] as String? ?? 'unknown',
      accuracyPercent: (json['accuracyPercent'] as num? ?? 0).toDouble(),
      isCorrect: json['isCorrect'] as bool? ?? false,
      landmarks: ((json['landmarks'] as List?) ?? const [])
          .map((item) => LandmarkPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
      feedbackText: json['feedbackText'] as String? ?? 'No feedback available.',
      feedbackColor: json['feedbackColor'] as String? ?? 'red',
      keyPointsCorrect: List<String>.from(
        (json['keyPointsCorrect'] as List?) ?? const [],
      ),
      keyPointsIncorrect: List<String>.from(
        (json['keyPointsIncorrect'] as List?) ?? const [],
      ),
      processingTimeMs: (json['processingTimeMs'] as num? ?? 0).toDouble(),
    );
  }
}
