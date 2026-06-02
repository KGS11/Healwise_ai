import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/audio_content.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key, required this.audio});

  final AudioContent audio;

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;

  bool _isLoading = true;
  String? _errorMessage;
  double _speed = 1.0;
  int _lastSavedSecond = -1;

  // Offline demo mode simulation states
  bool _isOfflineDemo = false;
  late Duration _demoDuration;
  Duration _demoPosition = Duration.zero;
  bool _demoPlaying = false;
  Timer? _demoTimer;

  @override
  void initState() {
    super.initState();
    _demoDuration = _parseDuration(widget.audio.duration);
    _prepareAudio();
  }

  Duration _parseDuration(String durationStr) {
    try {
      final parts = durationStr.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return Duration(minutes: minutes, seconds: seconds);
      }
    } catch (_) {}
    return const Duration(minutes: 5);
  }

  // Configures mobile session and loads network URL.
  // Automatically falls back to Demo Offline Mode if loading takes > 2.5s.
  Future<void> _prepareAudio() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isOfflineDemo = false;
    });

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      // Attempt to set the network URL with a strict 2.5s timeout limit
      await _player
          .setUrl(widget.audio.audioUrl)
          .timeout(const Duration(milliseconds: 2500));

      final savedPosition = await _loadSavedPosition();
      if (savedPosition > Duration.zero) {
        await _player.seek(savedPosition);
      }

      _positionSubscription?.cancel();
      _positionSubscription = _player.positionStream.listen((position) {
        if ((position.inSeconds - _lastSavedSecond).abs() >= 5) {
          _lastSavedSecond = position.inSeconds;
          unawaited(_savePosition(position));
        }
      });

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('[AudioPlayerScreen] Network stream unavailable or timed out: $e');
      debugPrint('[AudioPlayerScreen] Activating Demo Offline Mode fallback.');
      
      // Load saved position for offline demo mode
      final savedPos = await _loadSavedPosition();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOfflineDemo = true;
          _demoPosition = savedPos < _demoDuration ? savedPos : Duration.zero;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isOfflineDemo) {
      setState(() {
        _demoPlaying = !_demoPlaying;
        if (_demoPlaying) {
          _startDemoTimer();
        } else {
          _demoTimer?.cancel();
        }
      });
      return;
    }

    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _startDemoTimer() {
    _demoTimer?.cancel();
    _demoTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted) return;
      setState(() {
        final step = Duration(milliseconds: (200 * _speed).round());
        var target = _demoPosition + step;
        if (target >= _demoDuration) {
          target = _demoDuration;
          _demoPlaying = false;
          _demoTimer?.cancel();
        }
        _demoPosition = target;
        
        // Save progress periodically
        if ((_demoPosition.inSeconds - _lastSavedSecond).abs() >= 5) {
          _lastSavedSecond = _demoPosition.inSeconds;
          unawaited(_savePosition(_demoPosition));
        }
      });
    });
  }

  Future<void> _stopAudio() async {
    if (_isOfflineDemo) {
      setState(() {
        _demoPlaying = false;
        _demoPosition = Duration.zero;
        _demoTimer?.cancel();
      });
      unawaited(_savePosition(Duration.zero));
      return;
    }

    await _player.stop();
    await _player.seek(Duration.zero);
  }

  Future<void> _seekBy(Duration offset) async {
    if (_isOfflineDemo) {
      setState(() {
        var target = _demoPosition + offset;
        if (target < Duration.zero) target = Duration.zero;
        if (target > _demoDuration) target = _demoDuration;
        _demoPosition = target;
      });
      unawaited(_savePosition(_demoPosition));
      return;
    }

    final duration = _player.duration ?? Duration.zero;
    final current = _player.position;
    var target = current + offset;

    if (target < Duration.zero) {
      target = Duration.zero;
    }
    if (duration > Duration.zero && target > duration) {
      target = duration;
    }

    await _player.seek(target);
  }

  Future<void> _setSpeed(double speed) async {
    if (_isOfflineDemo) {
      setState(() {
        _speed = speed;
        if (_demoPlaying) {
          _startDemoTimer();
        }
      });
      return;
    }

    await _player.setSpeed(speed);
    if (mounted) {
      setState(() => _speed = speed);
    }
  }

  Future<void> _seekTo(Duration target) async {
    if (_isOfflineDemo) {
      setState(() {
        _demoPosition = target;
      });
      unawaited(_savePosition(_demoPosition));
      return;
    }
    await _player.seek(target);
  }

  Future<Duration> _loadSavedPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final milliseconds = prefs.getInt(_progressKey) ?? 0;
    return Duration(milliseconds: milliseconds);
  }

  Future<void> _savePosition(Duration position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_progressKey, position.inMilliseconds);
  }

  String get _progressKey => 'guidance_audio_position_${widget.audio.id}';

  @override
  void dispose() {
    _demoTimer?.cancel();
    final finalPos = _isOfflineDemo ? _demoPosition : _player.position;
    unawaited(_savePosition(finalPos));
    _positionSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF082F2A),
      appBar: AppBar(
        title: Text(
          widget.audio.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF064E3B), Color(0xFF082F2A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _errorMessage != null
              ? _AudioErrorState(
                  message: _errorMessage!,
                  onRetry: _prepareAudio,
                )
              : _AudioPlayerBody(
                  player: _player,
                  audio: widget.audio,
                  primaryColor: primaryColor,
                  speed: _speed,
                  isOfflineDemo: _isOfflineDemo,
                  demoPlaying: _demoPlaying,
                  demoPosition: _demoPosition,
                  demoDuration: _demoDuration,
                  onTogglePlayPause: _togglePlayPause,
                  onStop: _stopAudio,
                  onRewind: () => _seekBy(const Duration(seconds: -10)),
                  onForward: () => _seekBy(const Duration(seconds: 10)),
                  onSetSpeed: _setSpeed,
                  onSeekTo: _seekTo,
                ),
        ),
      ),
    );
  }
}

class _AudioPlayerBody extends StatelessWidget {
  const _AudioPlayerBody({
    required this.player,
    required this.audio,
    required this.primaryColor,
    required this.speed,
    required this.isOfflineDemo,
    required this.demoPlaying,
    required this.demoPosition,
    required this.demoDuration,
    required this.onTogglePlayPause,
    required this.onStop,
    required this.onRewind,
    required this.onForward,
    required this.onSetSpeed,
    required this.onSeekTo,
  });

  final AudioPlayer player;
  final AudioContent audio;
  final Color primaryColor;
  final double speed;
  final bool isOfflineDemo;
  final bool demoPlaying;
  final Duration demoPosition;
  final Duration demoDuration;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onStop;
  final VoidCallback onRewind;
  final VoidCallback onForward;
  final ValueChanged<double> onSetSpeed;
  final ValueChanged<Duration> onSeekTo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOfflineDemo) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.offline_bolt_rounded, color: Colors.greenAccent, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Demo Offline Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    Color.lerp(primaryColor, Colors.white, 0.18) ??
                        primaryColor,
                  ],
                ),
              ),
              child: Icon(
                _iconFor(audio.thumbnailEmoji),
                color: Colors.white,
                size: 54,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              audio.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              audio.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.76),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _InfoChip(label: audio.instructor),
                _InfoChip(label: audio.language),
              ],
            ),
            const SizedBox(height: 34),
            if (isOfflineDemo)
              _buildDemoSlider()
            else
              _buildRealPlayerSlider(),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: onRewind,
                  icon: const Icon(Icons.replay_10_rounded),
                ),
                const SizedBox(width: 14),
                if (isOfflineDemo)
                  _buildDemoPlayButton()
                else
                  _buildRealPlayButton(),
                const SizedBox(width: 14),
                IconButton.filledTonal(
                  onPressed: onStop,
                  icon: const Icon(Icons.stop_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                IconButton.filledTonal(
                  onPressed: onForward,
                  icon: const Icon(Icons.forward_10_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 8,
              children: [0.75, 1.0, 1.25, 1.5].map((item) {
                final selected = item == speed;
                return ChoiceChip(
                  label: Text('${item}x'),
                  selected: selected,
                  selectedColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? primaryColor : Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.28)),
                  onSelected: (_) => onSetSpeed(item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSlider() {
    final maxValue = demoDuration.inMilliseconds.toDouble();
    final value = demoPosition.inMilliseconds
        .clamp(0, demoDuration.inMilliseconds)
        .toDouble();

    return Column(
      children: [
        Slider(
          value: value,
          min: 0,
          max: maxValue == 0 ? 1 : maxValue,
          activeColor: Colors.white,
          inactiveColor: Colors.white.withValues(alpha: 0.22),
          onChanged: (newValue) {
            onSeekTo(Duration(milliseconds: newValue.round()));
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(demoPosition),
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                _formatDuration(demoDuration),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRealPlayerSlider() {
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      initialData: player.position,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final total = player.duration ?? Duration.zero;
        final maxValue = total.inMilliseconds.toDouble();
        final value = maxValue == 0
            ? 0.0
            : position.inMilliseconds
                  .clamp(0, total.inMilliseconds)
                  .toDouble();

        return Column(
          children: [
            Slider(
              value: value,
              min: 0,
              max: maxValue == 0 ? 1 : maxValue,
              activeColor: Colors.white,
              inactiveColor: Colors.white.withValues(alpha: 0.22),
              onChanged: maxValue == 0
                  ? null
                  : (newValue) {
                      onSeekTo(Duration(milliseconds: newValue.round()));
                    },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _formatDuration(total),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDemoPlayButton() {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTogglePlayPause,
      child: CircleAvatar(
        radius: 36,
        backgroundColor: Colors.white,
        child: Icon(
          demoPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 40,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildRealPlayButton() {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing ?? player.playing;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: primaryColor,
              ),
            ),
          );
        }

        return InkWell(
          customBorder: const CircleBorder(),
          onTap: onTogglePlayPause,
          child: CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(
              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 40,
              color: primaryColor,
            ),
          ),
        );
      },
    );
  }

  IconData _iconFor(String token) {
    return switch (token) {
      'sleep' => Icons.bedtime_rounded,
      'rain' => Icons.water_drop_outlined,
      'moon' => Icons.nightlight_round,
      'breathing' => Icons.air_rounded,
      'air' => Icons.wind_power_rounded,
      'sunset' => Icons.wb_twilight_rounded,
      'sparkle' => Icons.auto_awesome_rounded,
      _ => Icons.self_improvement_rounded,
    };
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) {
      return '$hours:${minutes.padLeft(2, '0')}:$seconds';
    }
    return '$minutes:$seconds';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.14),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
    );
  }
}

class _AudioErrorState extends StatelessWidget {
  const _AudioErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 52),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
