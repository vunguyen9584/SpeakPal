import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onReleased;
  final bool isRecording;

  const MicButton({
    Key? key,
    this.onPressed,
    this.onReleased,
    this.isRecording = false,
  }) : super(key: key);

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.onPressed?.call(),
      onTapUp: (_) => widget.onReleased?.call(),
      onTapCancel: () => widget.onReleased?.call(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isRecording ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isRecording ? Colors.red : Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: (widget.isRecording ? Colors.red : Theme.of(context).primaryColor)
                        .withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                widget.isRecording ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        },
      ),
    );
  }
}
