import 'package:flutter/material.dart';
import '../../domain/models/streak.dart';

class StreakWidget extends StatelessWidget {
  final Streak? streak;
  final VoidCallback? onUseFreeze;

  const StreakWidget({
    super.key,
    this.streak,
    this.onUseFreeze,
  });

  @override
  Widget build(BuildContext context) {
    if (streak == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Streak',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (streak!.streakFreezeCount > 0)
                  GestureDetector(
                    onTap: _showFreezeInfo,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.ac_unit, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            '${streak!.streakFreezeCount}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Streak counter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 48,
                  color: _getStreakColor(streak!.currentStreak),
                ),
                const SizedBox(width: 8),
                Text(
                  '${streak!.currentStreak}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getStreakColor(streak!.currentStreak),
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  'day${streak!.currentStreak != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Longest streak
            Text(
              'Longest: ${streak!.longestStreak} days',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),

            const SizedBox(height: 16),

            // Milestones
            if (streak!.milestones.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Milestones',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: streak!.milestones.map((milestone) {
                  return Chip(
                    label: Text(milestone),
                    avatar: const Icon(Icons.emoji_events, size: 16),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 16),

            // Motivation text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getMotivationText(streak!.currentStreak),
                      style: const TextStyle(color: Colors.orange),
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

  Color _getStreakColor(int days) {
    if (days >= 30) return Colors.red;
    if (days >= 7) return Colors.orange;
    return Colors.amber;
  }

  String _getMotivationText(int days) {
    if (days == 0) return "Start your streak today!";
    if (days == 1) return "Great start! Keep it going!";
    if (days < 7) return "You're on a roll! Don't break it!";
    if (days < 30) return "Awesome dedication! Keep pushing!";
    return "Incredible streak! You're unstoppable!";
  }

  void _showFreezeInfo() {
    // This would show a dialog explaining streak freeze
    // Implementation depends on BuildContext
  }
}

// Expandable version for detail screen
class StreakDetailWidget extends StatelessWidget {
  final Streak streak;
  final VoidCallback? onUseFreeze;

  const StreakDetailWidget({
    super.key,
    required this.streak,
    this.onUseFreeze,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreakWidget(streak: streak),

        // Calendar view
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Week',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildWeekCalendar(context),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Streak freeze
        if (streak.streakFreezeCount > 0 && onUseFreeze != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _showFreezeConfirmation,
              icon: const Icon(Icons.ac_unit),
              label: Text('Use Streak Freeze (${streak.streakFreezeCount} left)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWeekCalendar(BuildContext context) {
    final now = DateTime.now();
    final weekDays = List.generate(7, (i) {
      return now.subtract(Duration(days: 6 - i));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        final isToday = day.day == now.day &&
                       day.month == now.month &&
                       day.year == now.year;
        final isActive = streak.lastActivityDate != null &&
                        day.isBefore(streak.lastActivityDate!.add(const Duration(days: 1)));

        return Column(
          children: [
            Text(
              _getWeekdayName(day.weekday),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive ? Colors.orange : Colors.grey[200],
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: Center(
                child: isActive
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.grey),
                      ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'M';
      case 2: return 'T';
      case 3: return 'W';
      case 4: return 'T';
      case 5: return 'F';
      case 6: return 'S';
      case 7: return 'S';
      default: return '';
    }
  }

  void _showFreezeConfirmation() {
    if (onUseFreeze != null) {
      onUseFreeze!();
    }
  }
}
