import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../models/shadowing_models.dart';

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
  late AudioPlayer _player;
  double _speed = 1.0;
  bool _isPracticing = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    // TODO: Load audio from widget.content.audioUrl
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Audio player controls
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                children: [
                  // Play/Pause button
                  StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final isPlaying = playerState?.playing ?? false;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay_10),
                            iconSize: 32,
                            onPressed: () {
                              final position = _player.position;
                              _player.seek(position - const Duration(seconds: 10));
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                            iconSize: 64,
                            color: Colors.blue,
                            onPressed: () {
                              if (isPlaying) {
                                _player.pause();
                              } else {
                                _player.play();
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.forward_10),
                            iconSize: 32,
                            onPressed: () {
                              final position = _player.position;
                              _player.seek(position + const Duration(seconds: 10));
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Progress slider
                  StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _player.duration ?? Duration.zero;

                      return Column(
                        children: [
                          Slider(
                            value: position.inMilliseconds.toDouble(),
                            max: duration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              _player.seek(Duration(milliseconds: value.toInt()));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(position)),
                              Text(_formatDuration(duration)),
                            ],
                          ),
                        ],
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
                            _player.setSpeed(_speed);
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
                      widget.content.transcript,
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
                        _player.seek(Duration.zero);
                        _player.play();
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
    final hasHeadphones = await _checkHeadphones();
    
    if (!hasHeadphones && mounted) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ヘッドフォンを使用してください'),
          content: const Text(
            'より良い録音品質のため、ヘッドフォンの使用を推奨します。\n'
            'このまま続けますか？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('続ける'),
            ),
          ],
        ),
      );

      if (proceed != true) return;
    }

    setState(() {
      _isPracticing = true;
    });

    // TODO: Start simultaneous playback and recording
    _player.seek(Duration.zero);
    _player.play();

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

  Future<bool> _checkHeadphones() async {
    // TODO: Implement headphone detection
    return false;
  }

  void _stopPractice() {
    setState(() {
      _isPracticing = false;
    });
    _player.pause();
    
    // TODO: Show result screen
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
