import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveformWidget extends StatelessWidget {
  final Stream<double> amplitudeStream;
  final Color color;
  final int barCount;

  const WaveformWidget({
    super.key,
    required this.amplitudeStream,
    this.color = Colors.blue,
    this.barCount = 30,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: amplitudeStream,
      builder: (context, snapshot) {
        final amplitude = snapshot.data ?? 0.0;
        return CustomPaint(
          painter: WaveformPainter(
            amplitude: amplitude,
            color: color,
            barCount: barCount,
          ),
          size: Size(double.infinity, 60),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double amplitude;
  final Color color;
  final int barCount;

  WaveformPainter({
    required this.amplitude,
    required this.color,
    required this.barCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / barCount;
    final centerY = size.height / 2;
    final maxHeight = size.height * 0.8;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;
      
      // Create wave effect with random variation
      final random = math.Random(i);
      final variation = random.nextDouble() * 0.5 + 0.5;
      final barHeight = (amplitude * maxHeight * variation).clamp(5.0, maxHeight);

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}

