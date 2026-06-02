class YogaConstants {
  // Update this to your laptop IPv4 address from PowerShell `ipconfig`.
  static const String baseUrl = 'http://10.169.13.179:8000';

  static const String healthEndpoint = '/health';
  static const String posesEndpoint = '/poses';
  static const String detectPoseEndpoint = '/detect-pose';

  static const int connectionTimeoutSeconds = 5;
  static const int analysisTimeoutSeconds = 15;
  static const double correctAccuracyThreshold = 75.0;
}
