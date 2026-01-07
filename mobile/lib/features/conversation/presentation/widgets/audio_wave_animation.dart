import 'package:flutter/material.dart';
import 'dart:math' as math;

class AudioWaveAnimation extends StatefulWidget {
  final bool isPlaying;
  final Color color;
  final int barCount;

  const AudioWaveAnimation({
    Key? key,
    required this.isPlaying,
    this.color = Colors.blue,
    this.barCount = 5,
  }) : super(key: key);

  @override
  State<AudioWaveAnimation> createState() => _AudioWaveAnimationState();
}

class _AudioWaveAnimationState extends State<AudioWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AudioWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveAnimationPainter(
            animation: _controller.value,
            color: widget.color,
            barCount: widget.barCount,
            isPlaying: widget.isPlaying,
          ),
          size: const Size(60, 30),
        );
      },
    );
  }
}

class WaveAnimationPainter extends CustomPainter {
  final double animation;
  final Color color;
  final int barCount;
  final bool isPlaying;

  WaveAnimationPainter({
    required this.animation,
    required this.color,
    required this.barCount,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;
      
      // Calculate bar height with wave effect
      final phase = (animation * 2 * math.pi) + (i * math.pi / barCount);
      final heightMultiplier = isPlaying
          ? (math.sin(phase).abs() * 0.7 + 0.3)
          : 0.2;
      final barHeight = size.height * heightMultiplier;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveAnimationPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.isPlaying != isPlaying;
  }
}
