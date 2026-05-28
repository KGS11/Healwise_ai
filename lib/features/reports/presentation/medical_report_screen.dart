import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MedicalReportScreen extends StatefulWidget {
  const MedicalReportScreen({super.key, required this.languageName});

  final String languageName;

  @override
  State<MedicalReportScreen> createState() => _MedicalReportScreenState();
}

class _MedicalReportScreenState extends State<MedicalReportScreen> {
  String? _selectedFileName;
  bool _hasAnalysis = false;

  late final _ReportCopy _copy = _ReportCopy(widget.languageName);

  void _selectPlaceholderFile(ImageSource source) {
    setState(() {
      _selectedFileName = source == ImageSource.camera
          ? 'camera_scan_placeholder.jpg'
          : 'medical_report_placeholder.jpg';
      _hasAnalysis = false;
    });
  }

  void _analyzeReport() {
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_copy.selectFileFirst)));
      return;
    }

    setState(() {
      _hasAnalysis = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_copy.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ReportHeader(copy: _copy),
            const SizedBox(height: 14),
            _ActionButtons(
              copy: _copy,
              onUpload: () => _selectPlaceholderFile(ImageSource.gallery),
              onScan: () => _selectPlaceholderFile(ImageSource.camera),
            ),
            const SizedBox(height: 14),
            _FilePreviewCard(
              title: _copy.filePreview,
              fileName: _selectedFileName,
              emptyText: _copy.noFileSelected,
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _analyzeReport,
              icon: const Icon(Icons.analytics_outlined),
              label: Text(_copy.analyzeReport),
            ),
            const SizedBox(height: 14),
            if (_hasAnalysis) _AnalysisResultSection(copy: _copy),
          ],
        ),
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
  final VoidCallback onUpload;
  final VoidCallback onScan;

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
    required this.emptyText,
  });

  final String title;
  final String? fileName;
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
  const _AnalysisResultSection({required this.copy});

  final _ReportCopy copy;

  @override
  Widget build(BuildContext context) {
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
            _ResultMetric(
              icon: Icons.psychology_outlined,
              label: copy.stressLevel,
              value: 'Moderate',
              color: const Color(0xFFEA580C),
            ),
            _ResultMetric(
              icon: Icons.bedtime_outlined,
              label: copy.sleepQuality,
              value: 'Needs improvement',
              color: const Color(0xFF2563EB),
            ),
            _ResultMetric(
              icon: Icons.favorite_outline,
              label: copy.wellnessScore,
              value: '78 / 100',
              color: const Color(0xFF0F766E),
            ),
            const SizedBox(height: 10),
            Text(
              copy.suggestedRemedies,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            ...copy.remedies.map(
              (remedy) => Padding(
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
                    Expanded(child: Text(remedy)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
      ? 'Upload or scan reports. OCR and AI will be added later.'
      : 'Upload or scan reports. OCR and AI will be added later.';
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
  String get stressLevel => isKannada ? 'Stress Level' : 'Stress Level';
  String get sleepQuality => isKannada ? 'Sleep Quality' : 'Sleep Quality';
  String get wellnessScore => isKannada ? 'Wellness Score' : 'Wellness Score';
  String get suggestedRemedies =>
      isKannada ? 'Suggested Natural Remedies' : 'Suggested Natural Remedies';

  List<String> get remedies => const [
    'Practice 5 minutes of deep breathing twice daily.',
    'Drink enough water and follow a regular sleep time.',
    'Try light yoga or walking for 15 minutes.',
    'Consult a doctor for serious or persistent symptoms.',
  ];
}
