import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/yoga_api_service.dart';
import '../data/yoga_poses_data.dart';
import '../domain/pose_model.dart';
import 'widgets/pose_selection_card.dart';
import 'yoga_result_screen.dart';

class YogaScreen extends StatefulWidget {
  const YogaScreen({super.key});

  @override
  State<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  final _apiService = YogaApiService();
  final _imagePicker = ImagePicker();

  bool _isConnected = false;
  bool _isCheckingConnection = true;
  PoseModel? _selectedPose;
  File? _selectedImage;
  bool _isAnalyzing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkBackendConnection();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  Future<void> _checkBackendConnection() async {
    setState(() {
      _isCheckingConnection = true;
      _errorMessage = null;
    });

    final connected = await _apiService.checkConnection();
    if (!mounted) return;

    setState(() {
      _isConnected = connected;
      _isCheckingConnection = false;
    });
  }

  Future<void> _pickFromGallery() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _selectedImage = File(picked.path);
      _errorMessage = null;
    });
  }

  Future<void> _captureFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required.')),
      );
      return;
    }

    final picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 800,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _selectedImage = File(picked.path);
      _errorMessage = null;
    });
  }

  Future<void> _analyzeImage() async {
    if (_selectedPose == null) {
      setState(() => _errorMessage = 'Please select a target yoga pose.');
      return;
    }
    if (_selectedImage == null) {
      setState(() => _errorMessage = 'Please add a photo for analysis.');
      return;
    }
    if (!_isConnected) {
      setState(
        () => _errorMessage =
            'Backend is not connected. Start the Python server and retry.',
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.detectPose(
        imageFile: _selectedImage!,
        targetPose: _selectedPose!.id,
      );
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              YogaResultScreen(result: result, targetPose: _selectedPose!),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F766E);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yoga Pose Detection',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            Text(
              'AI-powered posture analysis',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.circle,
              size: 14,
              color: _isConnected ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ConnectionStatusCard(
                  isChecking: _isCheckingConnection,
                  isConnected: _isConnected,
                  onRetry: _checkBackendConnection,
                ),
                const SizedBox(height: 22),
                _SectionTitle(title: 'Step 1 - Select Target Pose'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: YogaPosesData.poses.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final pose = YogaPosesData.poses[index];
                      return PoseSelectionCard(
                        pose: pose,
                        isSelected: _selectedPose?.id == pose.id,
                        onTap: () => setState(() => _selectedPose = pose),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Step 2 - Add Your Photo'),
                const SizedBox(height: 10),
                _ImagePickerPanel(
                  selectedImage: _selectedImage,
                  onGalleryTap: _pickFromGallery,
                  onCameraTap: _captureFromCamera,
                  onClear: () => setState(() => _selectedImage = null),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  _ErrorMessage(message: _errorMessage!),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeImage,
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('Analyze Pose'),
                  ),
                ),
              ],
            ),
          ),
          if (_isAnalyzing) const _LoadingOverlay(),
        ],
      ),
    );
  }
}

class _ConnectionStatusCard extends StatelessWidget {
  const _ConnectionStatusCard({
    required this.isChecking,
    required this.isConnected,
    required this.onRetry,
  });

  final bool isChecking;
  final bool isConnected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isChecking) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(),
              SizedBox(height: 12),
              Text('Connecting to Yoga AI...'),
            ],
          ),
        ),
      );
    }

    if (!isConnected) {
      return Card(
        color: const Color(0xFFFFFBEB),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.wifi_off_rounded, color: Color(0xFFEA580C)),
                  SizedBox(width: 8),
                  Text(
                    'Backend Not Connected',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Start the Python server and update your laptop IP in yoga_constants.dart.',
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBBE7D0)),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'HealWise Yoga AI is ready',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePickerPanel extends StatelessWidget {
  const _ImagePickerPanel({
    required this.selectedImage,
    required this.onGalleryTap,
    required this.onCameraTap,
    required this.onClear,
  });

  final File? selectedImage;
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final image = selectedImage;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 210),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8E2DD)),
      ),
      child: image == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 42,
                  color: Color(0xFF647067),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Add a clear full-body yoga photo',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: onCameraTap,
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Camera'),
                    ),
                    OutlinedButton.icon(
                      onPressed: onGalleryTap,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Gallery'),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    image,
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onGalleryTap,
                        icon: const Icon(Icons.swap_horiz_rounded),
                        label: const Text('Change'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.outlined(
                      onPressed: onClear,
                      icon: const Icon(Icons.delete_outline_rounded),
                      tooltip: 'Remove photo',
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
        color: const Color(0xFF12342F),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626)),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.35),
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 14),
                Text(
                  'Analyzing posture...',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
