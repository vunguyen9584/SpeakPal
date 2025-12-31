import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../domain/models/streak.dart';
import 'streak_calendar.dart';

/// Reusable streak widget for home and profile screens
class StreakWidget extends StatefulWidget {
  final int currentStreak;
  final int freezeRemaining;
  final int nextMilestone;
  final bool atRisk;
  final List<StreakDay> recentDays;
  final VoidCallback? onTap;

  const StreakWidget({
    super.key,
    required this.currentStreak,
    required this.freezeRemaining,
    required this.nextMilestone,
    required this.atRisk,
    required this.recentDays,
    this.onTap,
  });

  @override
  State<StreakWidget> createState() => _StreakWidgetState();
}

class _StreakWidgetState extends State<StreakWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.currentStreak > 0 && !widget.atRisk) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StreakWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStreak > 0 && !widget.atRisk) {
      if (!_animationController.isAnimating) {
        _animationController.repeat(reverse: true);
      }
    } else {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.atRisk
                ? [Colors.orange.shade50, Colors.orange.shade100]
                : [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.atRisk
                ? Colors.orange.shade300
                : Colors.grey.shade300,
            width: widget.atRisk ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.atRisk
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.atRisk) _buildAtRiskWarning(context),
            _buildStreakHeader(context),
            const SizedBox(height: 16),
            _buildMilestoneProgress(context),
            const SizedBox(height: 16),
            StreakCalendar(days: widget.recentDays),
            const SizedBox(height: 12),
            _buildFreezeInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAtRiskWarning(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade800,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Streak at risk! Practice today to keep it alive.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakHeader(BuildContext context) {
    return Row(
      children: [
        // Fire icon with animation
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.currentStreak > 0
                        ? LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.red.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade400,
                            ],
                          ),
                    boxShadow: widget.currentStreak > 0
                        ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),

        // Streak count and label
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                baseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    widget.currentStreak.toString(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: widget.currentStreak > 0
                          ? Colors.orange.shade700
                          : Colors.grey.shade600,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'day${widget.currentStreak != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Current Streak',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneProgress(BuildContext context) {
    final daysToMilestone = widget.nextMilestone - widget.currentStreak;
    final progress = widget.currentStreak / widget.nextMilestone;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.flag,
                    size: 16,
                    color: Colors.purple.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Next Milestone',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900,
                    ),
                  ),
                ],
              ),
              Text(
                '$daysToMilestone days to ${widget.nextMilestone}!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.purple.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.purple.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreezeInfo(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.ac_unit,
          size: 18,
          color: Colors.blue.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          '${widget.freezeRemaining} Streak ${widget.freezeRemaining == 1 ? 'Freeze' : 'Freezes'}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
          ),
        ),
        const Spacer(),
        if (widget.freezeRemaining > 0)
          TextButton.icon(
            onPressed: () {
              // Will be implemented with providers
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Freeze functionality will be added with providers'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.blue.shade700,
            ),
            label: Text(
              'Learn more',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }
}
