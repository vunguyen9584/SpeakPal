import 'package:flutter/material.dart';
import '../../../auth/domain/models/user.dart';

/// Level Progress Widget
class LevelProgress extends StatelessWidget {
  final User user;

  const LevelProgress({
    super.key,
    required this.user,
  });

  String _getLevelName(Level level) {
    switch (level) {
      case Level.beginner:
        return 'Beginner';
      case Level.elementary:
        return 'Elementary';
      case Level.intermediate:
        return 'Intermediate';
      case Level.upperIntermediate:
        return 'Upper Intermediate';
      case Level.advanced:
        return 'Advanced';
    }
  }

  int _getXpForNextLevel() {
    // XP required for next level: 1000 * (level + 1)
    switch (user.level) {
      case Level.beginner:
        return 1000;
      case Level.elementary:
        return 2000;
      case Level.intermediate:
        return 3000;
      case Level.upperIntermediate:
        return 4000;
      case Level.advanced:
        return 5000;
    }
  }

  @override
  Widget build(BuildContext context) {
    final xpForNextLevel = _getXpForNextLevel();
    final progress = user.currentLevelXp / xpForNextLevel;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getLevelName(user.level),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${user.currentLevelXp} / $xpForNextLevel XP',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
