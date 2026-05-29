import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyzedReport {
  const AnalyzedReport({
    required this.reportId,
    required this.uploadedAt,
    required this.fileName,
    required this.extractedText,
    required this.analyzedParameters,
    required this.parameterStatuses,
    required this.healthSummary,
    required this.wellnessSuggestions,
    required this.reportType,
    required this.status,
  });

  final String reportId;
  final DateTime uploadedAt;
  final String fileName;
  final String extractedText;
  final Map<String, String> analyzedParameters;
  final Map<String, String> parameterStatuses;
  final String healthSummary;
  final List<String> wellnessSuggestions;
  final String reportType;
  final String status;

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'fileName': fileName,
      'extractedText': extractedText,
      'analyzedParameters': analyzedParameters,
      'healthSummary': healthSummary,
      'wellnessSuggestions': wellnessSuggestions,
      'reportType': reportType,
      'status': status,
    };
  }

  factory AnalyzedReport.fromMap(Map<String, dynamic> map) {
    final uploadedAt = map['uploadedAt'];

    return AnalyzedReport(
      reportId: map['reportId'] as String? ?? '',
      uploadedAt: uploadedAt is Timestamp
          ? uploadedAt.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      fileName: map['fileName'] as String? ?? '',
      extractedText: map['extractedText'] as String? ?? '',
      analyzedParameters: Map<String, String>.from(
        map['analyzedParameters'] as Map? ?? {},
      ),
      parameterStatuses: const {},
      healthSummary: map['healthSummary'] as String? ?? '',
      wellnessSuggestions: List<String>.from(
        map['wellnessSuggestions'] as List? ?? const [],
      ),
      reportType: map['reportType'] as String? ?? 'image',
      status: map['status'] as String? ?? 'analyzed',
    );
  }
}
