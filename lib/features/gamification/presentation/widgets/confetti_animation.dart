import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Confetti particle for celebration animation
class ConfettiParticle {
  Offset position;
  Offset velocity;
  Color color;
  double rotation;
  double rotationSpeed;
  double size;

  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
  });

  void update() {
    position = Offset(
      position.dx + velocity.dx,
      position.dy + velocity.dy,
    );
    velocity = Offset(
      velocity.dx,
      velocity.dy + 0.5, // Gravity
    );
    rotation += rotationSpeed;
  }
}

/// Confetti animation widget with falling particles
class ConfettiAnimation extends StatefulWidget {
  final int particleCount;

  const ConfettiAnimation({
    super.key,
    this.particleCount = 100,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;
  final math.Random _random = math.Random();

  final List<Color> _confettiColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _initializeParticles();
    _controller.addListener(_updateParticles);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      return ConfettiParticle(
        position: Offset(
          _random.nextDouble() * screenWidth,
          -_random.nextDouble() * screenHeight * 0.5,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 4,
          _random.nextDouble() * 2 + 3,
        ),
        color: _confettiColors[_random.nextInt(_confettiColors.length)],
        rotation: _random.nextDouble() * math.pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
        size: _random.nextDouble() * 8 + 4,
      );
    });
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        particle.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConfettiPainter(particles: _particles),
      child: Container(),
    );
  }
}

/// Custom painter for confetti particles
class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw confetti as small rectangles
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size * 1.5,
      );
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
