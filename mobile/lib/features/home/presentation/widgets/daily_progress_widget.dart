import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/dashboard_stats.dart';

class DailyProgressWidget extends ConsumerWidget {
  final DashboardStats stats;

  const DailyProgressWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Progress",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  StreakBadge(streak: stats.currentStreak),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: stats.progressPercentage,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  stats.progressPercentage >= 1.0
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${stats.todayMinutes}/${stats.dailyGoal} minutes',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (stats.todayMinutes >= stats.dailyGoal)
                    const Text(
                      '脂 Goal achieved!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              if (stats.todayMinutes < stats.dailyGoal) ...[
                const SizedBox(height: 12),
                Text(
                  _getEncouragementMessage(stats),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getEncouragementMessage(DashboardStats stats) {
    final remaining = stats.dailyGoal - stats.todayMinutes;
    if (remaining <= 5) {
      return 'Just $remaining more minutes to go!';
    } else if (remaining <= 15) {
      return "You're doing great! Keep it up!";
    } else {
      return 'Start a conversation to reach your daily goal!';
    }
  }
}

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '櫨',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          Text(
            '$streak day${streak != 1 ? 's' : ''}',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

