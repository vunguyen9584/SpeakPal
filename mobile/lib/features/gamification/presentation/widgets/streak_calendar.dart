import 'package:flutter/material.dart';
import '../../domain/models/streak.dart';

/// Mini 7-day calendar showing recent streak activity
class StreakCalendar extends StatelessWidget {
  final List<StreakDay> days;

  const StreakCalendar({
    super.key,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 7 Days',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) => _buildDayIndicator(context, day)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDayIndicator(BuildContext context, StreakDay day) {
    final isToday = _isToday(day.date);
    final dayName = _getDayName(day.date);

    return Column(
      children: [
        // Day name
        Text(
          dayName,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),

        // Day indicator
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getDayColor(context, day, isToday),
            shape: BoxShape.circle,
            border: Border.all(
              color: isToday
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: _getDayIcon(context, day),
          ),
        ),
        const SizedBox(height: 2),

        // Date number
        Text(
          day.date.day.toString(),
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Color _getDayColor(BuildContext context, StreakDay day, bool isToday) {
    if (day.wasFrozen) {
      return Colors.blue.shade100;
    } else if (day.hasActivity) {
      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.8);
    } else if (isToday) {
      return Colors.orange.shade100;
    } else {
      return Colors.grey.shade200;
    }
  }

  Widget _getDayIcon(BuildContext context, StreakDay day) {
    if (day.wasFrozen) {
      return Icon(
        Icons.ac_unit,
        size: 16,
        color: Colors.blue.shade700,
      );
    } else if (day.hasActivity) {
      return const Icon(
        Icons.check,
        size: 16,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.close,
        size: 16,
        color: Colors.grey.shade400,
      );
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
