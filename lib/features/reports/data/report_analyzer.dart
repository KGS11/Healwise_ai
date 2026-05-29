import '../domain/analyzed_report.dart';

class ReportAnalyzer {
  // Analyzes OCR text and returns a complete local report result.
  AnalyzedReport analyzeText({
    required String extractedText,
    required String fileName,
    required String reportType,
  }) {
    final parameters = <String, String>{
      'bloodPressure': detectBloodPressure(extractedText),
      'sugarLevel': detectSugarLevel(extractedText),
      'cholesterol': detectCholesterol(extractedText),
      'hemoglobin': detectHemoglobin(extractedText),
      'bmi': detectBmi(extractedText),
    };

    final statuses = _buildStatuses(parameters);

    return AnalyzedReport(
      reportId: DateTime.now().microsecondsSinceEpoch.toString(),
      uploadedAt: DateTime.now(),
      fileName: fileName,
      extractedText: extractedText,
      analyzedParameters: parameters,
      parameterStatuses: statuses,
      healthSummary: generateHealthSummary(parameters),
      wellnessSuggestions: generateWellnessSuggestions(statuses),
      reportType: reportType,
      status: 'analyzed',
    );
  }

  // Detects blood pressure values like 120/80 near BP keywords.
  String detectBloodPressure(String text) {
    if (!_containsAny(text, [
      'bp',
      'blood pressure',
      'systolic',
      'diastolic',
    ])) {
      return '';
    }
    return _valueNearKeywords(text, [
      'bp',
      'blood pressure',
      'systolic',
      'diastolic',
    ], RegExp(r'\b\d{2,3}\s*/\s*\d{2,3}\b'));
  }

  // Detects blood sugar values near glucose/sugar keywords.
  String detectSugarLevel(String text) {
    if (!_containsAny(text, ['glucose', 'sugar', 'fbs', 'rbs', 'hba1c'])) {
      return '';
    }
    return _valueNearKeywords(text, [
      'glucose',
      'sugar',
      'fbs',
      'rbs',
      'hba1c',
    ], _unitPattern('mg/dl'));
  }

  // Detects cholesterol values near lipid keywords.
  String detectCholesterol(String text) {
    if (!_containsAny(text, ['cholesterol', 'ldl', 'hdl', 'triglycerides'])) {
      return '';
    }
    return _valueNearKeywords(text, [
      'cholesterol',
      'ldl',
      'hdl',
      'triglycerides',
    ], _unitPattern('mg/dl'));
  }

  // Detects hemoglobin values near Hb keywords.
  String detectHemoglobin(String text) {
    if (!_containsAny(text, ['hemoglobin', 'haemoglobin', 'hb'])) {
      return '';
    }
    return _valueNearKeywords(text, [
      'hemoglobin',
      'haemoglobin',
      'hb',
    ], _unitPattern('g/dl'));
  }

  // Detects BMI decimal/integer values near BMI keywords.
  String detectBmi(String text) {
    if (!_containsAny(text, ['bmi', 'body mass index'])) {
      return '';
    }
    return _valueNearKeywords(text, [
      'bmi',
      'body mass index',
    ], RegExp(r'\b\d{2}(?:\.\d+)?\b'));
  }

  // Creates wellness suggestions from detected parameter statuses.
  List<String> generateWellnessSuggestions(Map<String, String> statuses) {
    final suggestions = <String>{};

    if (statuses['bloodPressure'] == 'High' ||
        statuses['bloodPressure'] == 'Critical') {
      suggestions.addAll([
        'Practice deep breathing exercises daily',
        'Reduce salt intake',
        'Try meditation for 10 minutes each morning',
      ]);
    }

    if (statuses['sugarLevel'] == 'High' ||
        statuses['sugarLevel'] == 'Critical') {
      suggestions.addAll([
        'Follow a low-glycemic diet',
        'Walk for 30 minutes after meals',
        'Practice yoga poses for diabetes management',
      ]);
    }

    if (statuses['cholesterol'] == 'High' ||
        statuses['cholesterol'] == 'Critical') {
      suggestions.addAll([
        'Include omega-3 rich foods in your diet',
        'Avoid fried and processed foods',
        'Try brisk walking for 45 minutes daily',
      ]);
    }

    if (statuses['hemoglobin'] == 'Low' ||
        statuses['hemoglobin'] == 'Critical') {
      suggestions.addAll([
        'Include iron-rich foods like spinach and dates',
        'Consult a naturopathy doctor',
        'Try sun exposure therapy in the morning',
      ]);
    }

    suggestions.add(
      'Consult a qualified doctor for professional medical advice',
    );
    return suggestions.toList();
  }

  // Creates a simple human-readable summary from detected values.
  String generateHealthSummary(Map<String, String> params) {
    final detected = params.entries.where((entry) => entry.value.isNotEmpty);

    if (detected.isEmpty) {
      return 'No standard parameters found. Please upload a clearer medical report. This analysis is for informational purposes only. Please consult a qualified medical professional for proper diagnosis and treatment.';
    }

    final names = detected.map((entry) => _labelFor(entry.key)).join(', ');
    return 'Detected these report parameters: $names. Review the status badges and wellness suggestions below. This analysis is for informational purposes only. Please consult a qualified medical professional for proper diagnosis and treatment.';
  }

  Map<String, String> _buildStatuses(Map<String, String> params) {
    return {
      'bloodPressure': _bloodPressureStatus(params['bloodPressure'] ?? ''),
      'sugarLevel': _numericStatus(
        params['sugarLevel'] ?? '',
        low: 70,
        high: 100,
        highOnlyCritical: 200,
      ),
      'cholesterol': _cholesterolStatus(params['cholesterol'] ?? ''),
      'hemoglobin': _numericStatus(
        params['hemoglobin'] ?? '',
        low: 12,
        high: 17,
        lowCritical: 8,
        highOnlyCritical: 20,
      ),
      'bmi': _numericStatus(
        params['bmi'] ?? '',
        low: 18.5,
        high: 24.9,
        lowCritical: 16,
        highOnlyCritical: 35,
      ),
    };
  }

  String _bloodPressureStatus(String value) {
    final parts = value.split('/');
    if (parts.length != 2) return 'Not found';

    final systolic = int.tryParse(parts[0].trim());
    final diastolic = int.tryParse(parts[1].trim());
    if (systolic == null || diastolic == null) return 'Not found';

    if (systolic >= 180 || diastolic >= 120) return 'Critical';
    if (systolic > 120 || diastolic > 80) return 'High';
    if (systolic < 90 || diastolic < 60) return 'Low';
    return 'Normal';
  }

  String _cholesterolStatus(String value) {
    final number = _firstNumber(value);
    if (number == null) return 'Not found';
    if (number >= 300) return 'Critical';
    if (number >= 200) return 'High';
    return 'Normal';
  }

  String _numericStatus(
    String value, {
    required double low,
    required double high,
    double? lowCritical,
    double? highOnlyCritical,
  }) {
    final number = _firstNumber(value);
    if (number == null) return 'Not found';
    if (lowCritical != null && number < lowCritical) return 'Critical';
    if (highOnlyCritical != null && number > highOnlyCritical) {
      return 'Critical';
    }
    if (number < low) return 'Low';
    if (number > high) return 'High';
    return 'Normal';
  }

  RegExp _unitPattern(String unit) {
    return RegExp(
      r'\b\d{2,3}(?:\.\d+)?\s*' + RegExp.escape(unit) + r'\b',
      caseSensitive: false,
    );
  }

  String _valueNearKeywords(
    String text,
    List<String> keywords,
    RegExp valuePattern,
  ) {
    final lines = text.split(RegExp(r'[\r\n]+'));

    for (final line in lines) {
      final lowerLine = line.toLowerCase();
      if (!keywords.any(lowerLine.contains)) continue;

      final match = valuePattern.firstMatch(line);
      if (match != null) return match.group(0) ?? '';
    }

    return valuePattern.firstMatch(text)?.group(0) ?? '';
  }

  double? _firstNumber(String value) {
    final match = RegExp(r'\d+(?:\.\d+)?').firstMatch(value);
    if (match == null) return null;
    return double.tryParse(match.group(0)!);
  }

  bool _containsAny(String text, List<String> keywords) {
    final lower = text.toLowerCase();
    return keywords.any(lower.contains);
  }

  String _labelFor(String key) {
    return switch (key) {
      'bloodPressure' => 'Blood Pressure',
      'sugarLevel' => 'Sugar Level',
      'cholesterol' => 'Cholesterol',
      'hemoglobin' => 'Hemoglobin',
      'bmi' => 'BMI',
      _ => key,
    };
  }
}
