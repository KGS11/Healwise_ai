import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../domain/video_content.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.video});

  final VideoContent video;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final YoutubePlayerController _controller;
  bool _hasVideoError = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeVideoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    )..addListener(_onPlayerChanged);
  }

  void _onPlayerChanged() {
    if (!mounted) return;
    final hasError = _controller.value.errorCode != 0;
    if (hasError != _hasVideoError) {
      setState(() => _hasVideoError = hasError);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _hasVideoError = false;
    });
    _controller.load(widget.video.youtubeVideoId);
  }

  Future<void> _openInYouTube() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=${widget.video.youtubeVideoId}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback launch
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint('[VideoPlayerScreen] Could not launch YouTube external link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).colorScheme.primary,
        progressColors: ProgressBarColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.video.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: _hasVideoError
              ? _VideoErrorState(
                  onBack: () => Navigator.of(context).pop(),
                  onRetry: _retry,
                  onOpenYouTube: _openInYouTube,
                )
              : Column(
                  children: [
                    ColoredBox(color: Colors.black, child: player),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(18),
                        child: _VideoDetails(video: widget.video),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _VideoDetails extends StatelessWidget {
  const _VideoDetails({required this.video});

  final VideoContent video;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          video.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: const Color(0xFF12342F),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.person_outline_rounded, color: primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                video.instructor,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _DetailChip(label: video.duration, icon: Icons.schedule_rounded),
            _DetailChip(label: video.language, icon: Icons.language_rounded),
          ],
        ),
        const SizedBox(height: 18),
        const Divider(),
        const SizedBox(height: 10),
        Text(
          video.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: const Color(0xFF475750),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withValues(alpha: 0.16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.spa_rounded, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Wellness Tip',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF12342F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Practice this regularly for best results. Consistency is key in naturopathy healing.',
                style: TextStyle(height: 1.4, color: Color(0xFF475750)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 17),
      label: Text(label),
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide.none,
    );
  }
}

class _VideoErrorState extends StatelessWidget {
  const _VideoErrorState({
    required this.onBack,
    required this.onRetry,
    required this.onOpenYouTube,
  });

  final VoidCallback onBack;
  final VoidCallback onRetry;
  final VoidCallback onOpenYouTube;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.video_library_outlined, size: 54, color: Colors.red),
            const SizedBox(height: 14),
            const Text(
              'Video unavailable or connection error. Try playing again or view externally.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Go back'),
                ),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
                FilledButton.icon(
                  onPressed: onOpenYouTube,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open in YouTube'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
