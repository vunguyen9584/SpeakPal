import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../models/models.dart';
import '../services/shadowing_audio_service.dart';
import '../services/audio_cache_service.dart';
import '../widgets/audio_waveform_visualizer.dart';
import '../utils/headphone_detector.dart';
import 'package:mobile/core/error/error_handler.dart';

class ShadowingPlayerScreen extends ConsumerStatefulWidget {
  final ShadowingContent content;

  const ShadowingPlayerScreen({
    required this.content,
    super.key,
  });

  @override
  ConsumerState<ShadowingPlayerScreen> createState() =>
      _ShadowingPlayerScreenState();
}

class _ShadowingPlayerScreenState
    extends ConsumerState<ShadowingPlayerScreen> {
  late ShadowingAudioService _audioService;
  double _speed = 1.0;
  bool _isPracticing = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _audioService = ShadowingAudioService();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final cacheService = AudioCacheService();
      final localPath = await cacheService.getOrDownloadAudio(widget.content.audioUrl);
      
      await _audioService.initialize(localPath);
      if (mounted) setState(() => _isReady = true);
    } catch (e) {
      if (mounted) {
        ErrorHandler.handle(e, StackTrace.current);
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load audio')),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
      ),
      body: SafeArea(
        child: !_isReady 
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Audio player controls
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                children: [
                  // Play/Pause button
                  StreamBuilder<PlayerState>(
                    stream: _audioService.modelPlayerState,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final isPlaying = playerState?.playing ?? false;

                      return StreamBuilder<Duration>(
                        stream: _audioService.modelPosition,
                        builder: (context, positionSnapshot) {
                          final currentPosition = positionSnapshot.data ?? Duration.zero;
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.replay_10),
                                iconSize: 32,
                                onPressed: () {
                                  _audioService.seekModel(
                                    currentPosition - const Duration(seconds: 10),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                                iconSize: 64,
                                color: Colors.blue,
                                onPressed: () {
                                  if (isPlaying) {
                                    _audioService.pauseModel();
                                  } else {
                                    _audioService.playModel();
                                  }
                                },
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.forward_10),
                                iconSize: 32,
                                onPressed: () {
                                  _audioService.seekModel(
                                    currentPosition + const Duration(seconds: 10),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Waveform and Slider
                  StreamBuilder<Duration>(
                    stream: _audioService.modelPosition,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      
                      return StreamBuilder<Duration>(
                        stream: _audioService.modelDuration,
                        builder: (context, durationSnapshot) {
                          final duration = durationSnapshot.data ?? Duration.zero;

                          return Column(
                            children: [
                              AudioWaveformVisualizer(
                                position: position,
                                duration: duration,
                                segments: widget.content.segments,
                              ),
                              const SizedBox(height: 8),
                              Slider(
                                value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
                                max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                                onChanged: (value) {
                                  _audioService.seekModel(Duration(milliseconds: value.toInt()));
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(position), style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(_formatDuration(duration), style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Speed control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('速度: '),
                      SegmentedButton<double>(
                        segments: const [
                          ButtonSegment(value: 0.75, label: Text('0.75x')),
                          ButtonSegment(value: 1.0, label: Text('1.0x')),
                          ButtonSegment(value: 1.25, label: Text('1.25x')),
                        ],
                        selected: {_speed},
                        onSelectionChanged: (Set<double> newSelection) {
                          setState(() {
                            _speed = newSelection.first;
                            _audioService.setModelSpeed(_speed);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Transcript
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'トランスクリプト',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.content.text,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _audioService.seekModel(Duration.zero);
                        _audioService.playModel();
                      },
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('最初から'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isPracticing ? null : _startPractice,
                      icon: const Icon(Icons.mic),
                      label: const Text('練習開始'),
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

  void _startPractice() async {
    // Check headphones
    final hasHeadphones = await HeadphoneDetector.areHeadphonesConnected();
    
    if (!hasHeadphones && mounted) {
      await HeadphoneDetector.showHeadphoneWarning(context);
    }

    setState(() {
      _isPracticing = true;
    });

    // Start simultaneous playback and recording
    // In production, this would:
    // 1. Start audio recording service
    // 2. Play model audio
    // 3. Record user's shadowing attempt
    // Example: await ref.read(audioRecorderProvider).startRecording();
    _audioService.seekModel(Duration.zero);
    _audioService.playModel();

    // Show recording overlay
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('録音中...'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _stopPractice();
                },
                child: const Text('停止'),
              ),
            ],
          ),
        ),
      );
    }
  }


  void _stopPractice() {
    setState(() {
      _isPracticing = false;
    });
    _audioService.pauseModel();
    
    // Navigate to result screen with shadowing results
    // In production, this would analyze the recording and show detailed feedback
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/shadowing/result',
        arguments: {
          'contentId': widget.content.id,
          'contentTitle': widget.content.title,
        },
      );
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

