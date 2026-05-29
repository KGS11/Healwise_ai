import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/ocr_service.dart';
import '../data/report_analyzer.dart';
import '../data/report_repository.dart';
import '../domain/analyzed_report.dart';

class MedicalReportScreen extends StatefulWidget {
  const MedicalReportScreen({super.key, required this.languageName});

  final String languageName;

  @override
  State<MedicalReportScreen> createState() => _MedicalReportScreenState();
}

class _MedicalReportScreenState extends State<MedicalReportScreen> {
  static const _maxFileBytes = 10 * 1024 * 1024;

  final _imagePicker = ImagePicker();
  final _ocrService = OcrService();
  final _reportAnalyzer = ReportAnalyzer();
  final _reportRepository = ReportRepository();

  File? _selectedFile;
  String? _selectedFileName;
  String? _reportType;
  AnalyzedReport? _analyzedReport;
  bool _isProcessing = false;
  bool _isSaving = false;

  late final _ReportCopy _copy = _ReportCopy(widget.languageName);

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  // Opens the file picker for PDF and image medical reports.
  Future<void> _pickReportFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result == null || result.files.single.path == null) {
        debugPrint('[ReportScreen] File picker canceled.');
        return;
      }

      final file = File(result.files.single.path!);
      debugPrint('[ReportScreen] [FILE_SELECTION] Selected file: ${file.path}, name: ${result.files.single.name}, size: ${file.lengthSync()} bytes');

      if (!_isValidFileSize(file)) {
        debugPrint('[ReportScreen] [FILE_SELECTION] Selected file size exceeds limit.');
        return;
      }

      final extension = _extensionOf(file.path);
      await _setSelectedFile(
        file: file,
        fileName: result.files.single.name,
        reportType: extension == 'pdf' ? 'pdf' : 'image',
      );
    } catch (error) {
      debugPrint('[ReportScreen] [FILE_SELECTION] File picker failed: $error');
      _showSnackBar('Could not open file picker. Please try again.');
    }
  }

  // Opens the camera and stores the captured image for OCR.
  Future<void> _scanUsingCamera() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (pickedImage == null) {
        debugPrint('[ReportScreen] Camera capture canceled.');
        return;
      }

      final file = File(pickedImage.path);
      debugPrint('[ReportScreen] [FILE_SELECTION] Camera scan captured file: ${file.path}, size: ${file.lengthSync()} bytes');

      if (!_isValidFileSize(file)) {
        debugPrint('[ReportScreen] [FILE_SELECTION] Scanned image size exceeds limit.');
        return;
      }

      await _setSelectedFile(
        file: file,
        fileName: _fileNameFromPath(file.path),
        reportType: 'image',
      );
    } on PlatformException catch (error) {
      debugPrint('[ReportScreen] [FILE_SELECTION] Camera PlatformException: ${error.code}');
      _showSnackBar(
        'Camera permission denied. Please enable camera access in app settings.',
      );
    } catch (error) {
      debugPrint('[ReportScreen] [FILE_SELECTION] Camera capture failed: $error');
      _showSnackBar('Could not open camera. Please try again.');
    }
  }

  // Stores selected file metadata and clears any previous analysis.
  Future<void> _setSelectedFile({
    required File file,
    required String fileName,
    required String reportType,
  }) async {
    if (mounted) {
      setState(() {
        _selectedFile = file;
        _selectedFileName = fileName;
        _reportType = reportType;
        _analyzedReport = null;
      });
    }
  }

  // Runs OCR, local parameter analysis, and Firestore save.
  Future<void> _analyzeReport() async {
    final file = _selectedFile;
    final fileName = _selectedFileName;
    final reportType = _reportType;

    if (file == null || fileName == null || reportType == null) {
      _showSnackBar(_copy.selectFileFirst);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final stopwatch = Stopwatch()..start();
    debugPrint('[ReportScreen] [OCR_START] Starting OCR analysis for $fileName ($reportType)');

    try {
      // 6. Timeout protection for the OCR engine
      final extractedText = await (reportType == 'pdf'
          ? _ocrService.extractTextFromPdf(file)
          : _ocrService.extractTextFromImage(file)
      ).timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          debugPrint('[ReportScreen] [OCR_ERROR] OCR extraction timed out for $fileName');
          throw const OcrTimeoutException('OCR text recognition timed out. Please try again with a clearer or smaller file.');
        },
      );

      debugPrint('[ReportScreen] [OCR_COMPLETE] OCR text extraction succeeded in ${stopwatch.elapsedMilliseconds}ms. Extracted text length: ${extractedText.length}');

      if (extractedText.trim().isEmpty) {
        debugPrint('[ReportScreen] [OCR_ERROR] Extracted text is empty.');
        _showSnackBar('Could not read report. Please upload a clearer file.');
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
        return;
      }

      final analyzedReport = _reportAnalyzer.analyzeText(
        extractedText: extractedText,
        fileName: fileName,
        reportType: reportType,
      );

      // 3. Properly dismiss the full-screen loading dialog BEFORE Firestore saving.
      // This allows the user to immediately view local results on the UI.
      if (mounted) {
        setState(() {
          _analyzedReport = analyzedReport;
          _isProcessing = false;
        });
      }

      if (!_hasDetectedParameters(analyzedReport)) {
        _showSnackBar(
          'No standard parameters found. Please upload a clearer medical report.',
        );
      }

      // 6. Firestore save handles its own internal timeout and is caught gracefully.
      await _saveReport(showSuccessMessage: true);
    } on OcrTimeoutException catch (error) {
      debugPrint('[ReportScreen] [OCR_ERROR] OCR timed out: $error');
      _showSnackBar(error.message);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (error) {
      debugPrint('[ReportScreen] [OCR_ERROR] OCR failed: $error');
      // 7. Show user-friendly error messages if OCR fails
      _showSnackBar('OCR Analysis failed. Please ensure the file is valid and Google Play Services are updated.');
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Saves the current analyzed report to Firestore with timeout protection.
  Future<void> _saveReport({bool showSuccessMessage = true}) async {
    final report = _analyzedReport;
    if (report == null) {
      _showSnackBar('Analyze a report before saving.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    debugPrint('[ReportScreen] [FIRESTORE_SAVE_START] UI triggered save. Checking local states...');

    try {
      debugPrint('[ReportScreen] [FIRESTORE_SAVE_CALL] Awaiting repository saveReport with 8s timeout...');
      await _reportRepository.saveReport(report).timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          debugPrint('[ReportScreen] [FIRESTORE_SAVE_TIMEOUT] Firestore save timed out after 8s.');
          throw const ReportRepositoryException('Cloud saving timed out due to slow network.');
        },
      );
      
      debugPrint('[ReportScreen] [FIRESTORE_SAVE_SUCCESS] Cloud save completed and acknowledged.');
      if (showSuccessMessage) {
        _showSnackBar('Report analyzed and saved successfully to the cloud.');
      }
    } on ReportRepositoryException catch (error) {
      debugPrint('[ReportScreen] [FIRESTORE_SAVE_WARNING] Firestore save warning: ${error.message}');
      
      // Task 6 & 7: Graceful offline fallback and detailed error reporting
      if (error.message.toLowerCase().contains('timed out') || 
          error.message.toLowerCase().contains('network') ||
          error.message.toLowerCase().contains('slow')) {
        _showSnackBar(
          'Saved locally (offline). It will sync automatically when network returns.',
          action: SnackBarAction(
            label: 'Retry Upload', 
            onPressed: () => _saveReport(showSuccessMessage: true),
          ),
        );
      } else {
        _showSnackBar(
          'Saved locally. Cloud upload failed: ${error.message}',
          action: SnackBarAction(
            label: 'Retry', 
            onPressed: () => _saveReport(showSuccessMessage: true),
          ),
        );
      }
    } catch (error) {
      debugPrint('[ReportScreen] [FIRESTORE_SAVE_ERROR] Unexpected error during save: $error');
      _showSnackBar(
        'Saved locally. Cloud upload error: $error',
        action: SnackBarAction(
          label: 'Retry', 
          onPressed: () => _saveReport(showSuccessMessage: true),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  bool _isValidFileSize(File file) {
    final size = file.lengthSync();
    if (size > _maxFileBytes) {
      _showSnackBar('File is too large. Please select a file below 10MB.');
      return false;
    }
    return true;
  }

  bool _hasDetectedParameters(AnalyzedReport report) {
    return report.analyzedParameters.values.any((value) => value.isNotEmpty);
  }

  String _extensionOf(String path) {
    final fileName = _fileNameFromPath(path);
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1) return '';
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  String _fileNameFromPath(String path) {
    return path.split(RegExp(r'[\\/]')).last;
  }

  void _showSnackBar(String message, {SnackBarAction? action}) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), action: action));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_copy.title)),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ReportHeader(copy: _copy),
                const SizedBox(height: 14),
                _ActionButtons(
                  copy: _copy,
                  onUpload: _isProcessing ? null : _pickReportFile,
                  onScan: _isProcessing ? null : _scanUsingCamera,
                ),
                const SizedBox(height: 14),
                _FilePreviewCard(
                  title: _copy.filePreview,
                  fileName: _selectedFileName,
                  reportType: _reportType,
                  emptyText: _copy.noFileSelected,
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _isProcessing ? null : _analyzeReport,
                  icon: const Icon(Icons.analytics_outlined),
                  label: Text(_copy.analyzeReport),
                ),
                const SizedBox(height: 14),
                if (_analyzedReport != null)
                  _AnalysisResultSection(
                    copy: _copy,
                    report: _analyzedReport!,
                    isSaving: _isSaving,
                    onSave: () => _saveReport(),
                  ),
              ],
            ),
          ),
          if (_isProcessing) const _LoadingOverlay(),
        ],
      ),
    );
  }
}

class _ReportHeader extends StatelessWidget {
  const _ReportHeader({required this.copy});

  final _ReportCopy copy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  copy.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  copy.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.copy,
    required this.onUpload,
    required this.onScan,
  });

  final _ReportCopy copy;
  final VoidCallback? onUpload;
  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.upload_file_outlined),
            label: Text(copy.uploadReport),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onScan,
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(copy.scanCamera),
          ),
        ),
      ],
    );
  }
}

class _FilePreviewCard extends StatelessWidget {
  const _FilePreviewCard({
    required this.title,
    required this.fileName,
    required this.reportType,
    required this.emptyText,
  });

  final String title;
  final String? fileName;
  final String? reportType;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                hasFile ? Icons.insert_drive_file_outlined : Icons.folder_open,
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fileName ?? emptyText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645F),
                    ),
                  ),
                  if (reportType != null) ...[
                    const SizedBox(height: 6),
                    Chip(label: Text(reportType!.toUpperCase())),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisResultSection extends StatelessWidget {
  const _AnalysisResultSection({
    required this.copy,
    required this.report,
    required this.isSaving,
    required this.onSave,
  });

  final _ReportCopy copy;
  final AnalyzedReport report;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final entries = report.analyzedParameters.entries.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              copy.analysisResult,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            for (final entry in entries)
              _ParameterCard(
                label: copy.parameterLabel(entry.key),
                value: entry.value.isEmpty ? 'Not found' : entry.value,
                status: report.parameterStatuses[entry.key] ?? 'Not found',
              ),
            const SizedBox(height: 10),
            Text(
              'Health Summary',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              report.healthSummary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF53645F),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              copy.suggestedRemedies,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            ...report.wellnessSuggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(suggestion)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: isSaving ? null : onSave,
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: const Text('Save to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParameterCard extends StatelessWidget {
  const _ParameterCard({
    required this.label,
    required this.value,
    required this.status,
  });

  final String label;
  final String value;
  final String status;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'Normal' => const Color(0xFF16A34A),
      'High' => const Color(0xFFEA580C),
      'Low' => const Color(0xFFEAB308),
      'Critical' => const Color(0xFFDC2626),
      _ => const Color(0xFF647067),
    };
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.18),
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Reading and analyzing report...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportCopy {
  const _ReportCopy(this.languageName);

  final String languageName;

  bool get isKannada => languageName.toLowerCase() == 'kannada';

  String get title =>
      isKannada ? 'Medical Report Analyzer' : 'Medical Report Analyzer';
  String get subtitle => isKannada
      ? 'Upload or scan reports. OCR analysis runs on your device.'
      : 'Upload or scan reports. OCR analysis runs on your device.';
  String get uploadReport => isKannada ? 'Upload Report' : 'Upload Report';
  String get scanCamera => isKannada ? 'Scan Camera' : 'Scan Using Camera';
  String get filePreview => isKannada ? 'File Preview' : 'File Preview';
  String get noFileSelected =>
      isKannada ? 'No report selected yet.' : 'No report selected yet.';
  String get analyzeReport => isKannada ? 'Analyze Report' : 'Analyze Report';
  String get selectFileFirst => isKannada
      ? 'Please select a report first.'
      : 'Please select a report first.';
  String get analysisResult =>
      isKannada ? 'Analysis Result' : 'Analysis Result';
  String get suggestedRemedies =>
      isKannada ? 'Suggested Natural Remedies' : 'Suggested Natural Remedies';

  String parameterLabel(String key) {
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
