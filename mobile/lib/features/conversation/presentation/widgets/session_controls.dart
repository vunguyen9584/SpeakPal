import 'package:flutter/material.dart';
import 'dart:async';

class SessionControls extends StatefulWidget {
  final DateTime startTime;
  final VoidCallback onEndPressed;
  final VoidCallback onSettingsPressed;

  const SessionControls({
    super.key,
    required this.startTime,
    required this.onEndPressed,
    required this.onSettingsPressed,
  });

  @override
  State<SessionControls> createState() => _SessionControlsState();
}

class _SessionControlsState extends State<SessionControls> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateElapsed();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateElapsed();
    });
  }

  void _updateElapsed() {
    setState(() {
      _elapsed = DateTime.now().difference(widget.startTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onEndPressed,
            tooltip: 'End Conversation',
          ),
          Text(
            _formatDuration(_elapsed),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onSettingsPressed,
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
