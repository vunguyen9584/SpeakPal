import 'package:flutter/material.dart';
import 'dart:async';
import 'confetti_animation.dart';

/// Full-screen level up celebration animation
class LevelUpAnimation extends StatefulWidget {
  final int oldLevel;
  final int newLevel;
  final int currentXp;
  final int xpForNextLevel;
  final VoidCallback onDismiss;

  const LevelUpAnimation({
    super.key,
    required this.oldLevel,
    required this.newLevel,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.onDismiss,
  });

  /// Show the level up animation as a full screen overlay
  static void show(
    BuildContext context, {
    required int oldLevel,
    required int newLevel,
    required int currentXp,
    required int xpForNextLevel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) => LevelUpAnimation(
        oldLevel: oldLevel,
        newLevel: newLevel,
        currentXp: currentXp,
        xpForNextLevel: xpForNextLevel,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<LevelUpAnimation> createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<LevelUpAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _levelTransitionController;
  late AnimationController _xpBarController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<int> _levelAnimation;
  late Animation<double> _xpBarAnimation;

  bool _showContinueButton = false;

  @override
  void initState() {
    super.initState();

    // Scale animation for the main content
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Level number transition
    _levelTransitionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _levelAnimation = IntTween(
      begin: widget.oldLevel,
      end: widget.newLevel,
    ).animate(CurvedAnimation(
      parent: _levelTransitionController,
      curve: Curves.easeInOut,
    ));

    // XP bar fill animation
    _xpBarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _xpBarAnimation = CurvedAnimation(
      parent: _xpBarController,
      curve: Curves.easeOut,
    );

    _startAnimationSequence();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _levelTransitionController.dispose();
    _xpBarController.dispose();
    super.dispose();
  }

  void _startAnimationSequence() async {
    // Start fade in
    _fadeController.forward();

    // Delay then start scale
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();

    // Start level transition
    await Future.delayed(const Duration(milliseconds: 400));
    _levelTransitionController.forward();

    // Start XP bar
    await Future.delayed(const Duration(milliseconds: 600));
    _xpBarController.forward();

    // Show continue button
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _showContinueButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Confetti background
          const Positioned.fill(
            child: ConfettiAnimation(particleCount: 100),
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildContent(context),
              ),
            ),
          ),

          // Continue button
          if (_showContinueButton)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: _buildContinueButton(context),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.95),
            Theme.of(context).colorScheme.secondary.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trophy icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.yellow.shade400,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // "LEVEL UP!" text
          const Text(
            'LEVEL UP!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),

          // Level number transition
          AnimatedBuilder(
            animation: _levelAnimation,
            builder: (context, child) {
              return Text(
                'Level ${_levelAnimation.value}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Congratulations message
          Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ve reached level ${widget.newLevel}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 32),

          // XP Progress bar
          _buildXpProgressBar(context),
        ],
      ),
    );
  }

  Widget _buildXpProgressBar(BuildContext context) {
    final progress = widget.currentXp / widget.xpForNextLevel;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'XP Progress',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Text(
              '${widget.currentXp} / ${widget.xpForNextLevel}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _xpBarAnimation,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: (progress * _xpBarAnimation.value).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow.shade300,
                              Colors.yellow.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _showContinueButton ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: widget.onDismiss,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
