import 'package:flutter/material.dart';
import '../models/shadowing_content.dart';

class AudioWaveformVisualizer extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final List<TextSegment> segments;

  const AudioWaveformVisualizer({
    super.key,
    required this.position,
    required this.duration,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    if (duration == Duration.zero) return const SizedBox(height: 100);

    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background segments
          CustomPaint(
            size: Size.infinite,
            painter: WaveformPainter(
              position: position,
              duration: duration,
              segments: segments,
              activeColor: Colors.blue.shade400,
              inactiveColor: Colors.grey.shade300,
            ),
          ),
          
          // Current position indicator
          LayoutBuilder(builder: (context, constraints) {
            final progress = position.inMilliseconds / duration.inMilliseconds;
            return Positioned(
              left: constraints.maxWidth * progress,
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                color: Colors.red.shade400,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final Duration position;
  final Duration duration;
  final List<TextSegment> segments;
  final Color activeColor;
  final Color inactiveColor;

  WaveformPainter({
    required this.position,
    required this.duration,
    required this.segments,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 3.0;
    final spacing = 1.0;
    final totalBars = (size.width / (barWidth + spacing)).floor();
    
    // Simple deterministic waveform based on segments and index
    for (var i = 0; i < totalBars; i++) {
      final barProgress = i / totalBars;
      final currentTimeMs = barProgress * duration.inMilliseconds;
      
      // Determine height: higher if in a segment, lower if in silence
      bool isInSegment = segments.any((s) => 
        currentTimeMs >= s.startTime.inMilliseconds && 
        currentTimeMs <= s.endTime.inMilliseconds
      );
      
      // Pseudo-random but consistent height
      double baseHeight = 0.3;
      if (isInSegment) {
        // Higher amplitude for speech segments
        baseHeight = 0.5 + (0.4 * ((i * 123.456) % 1.0));
      } else {
        baseHeight = 0.1 + (0.2 * ((i * 789.012) % 1.0));
      }
      
      final barHeight = size.height * baseHeight;
      final x = i * (barWidth + spacing);
      final y = (size.height - barHeight) / 2;
      
      final paint = Paint()
        ..color = currentTimeMs <= position.inMilliseconds ? activeColor : inactiveColor
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.position != position || oldDelegate.segments != segments;
  }
}
