import 'package:flutter/material.dart';
import '../../domain/models/history_item.dart';

/// Individual history item widget displaying a single activity
class HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback? onTap;

  const HistoryListItem({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            // Type Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getTypeColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTypeIcon(),
                color: _getTypeColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type label and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getTypeColor(),
                        ),
                      ),
                      Text(
                        _formatTime(item.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // XP earned
                  if (item.xpEarned > 0)
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          size: 14,
                          color: Colors.orange.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${item.xpEarned} XP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Chevron for tappable items
            if (item.type == HistoryActivityType.conversation)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (item.type) {
      case HistoryActivityType.conversation:
        return Icons.chat;
      case HistoryActivityType.vocabularyReview:
        return Icons.book;
      case HistoryActivityType.challenge:
        return Icons.flag;
      case HistoryActivityType.badgeEarned:
        return Icons.emoji_events;
      case HistoryActivityType.levelUp:
        return Icons.trending_up;
    }
  }

  Color _getTypeColor() {
    switch (item.type) {
      case HistoryActivityType.conversation:
        return Colors.blue;
      case HistoryActivityType.vocabularyReview:
        return Colors.purple;
      case HistoryActivityType.challenge:
        return Colors.green;
      case HistoryActivityType.badgeEarned:
        return Colors.amber;
      case HistoryActivityType.levelUp:
        return Colors.orange;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final amPm = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $amPm';
    }
  }
}
