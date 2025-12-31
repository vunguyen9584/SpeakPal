import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/badge.dart';

/// Individual badge item displayed in grid
class BadgeGridItem extends StatelessWidget {
  final Badge badge;
  final VoidCallback onTap;

  const BadgeGridItem({
    super.key,
    required this.badge,
    required this.onTap,
  });

  bool get isEarned => badge.earnedAt != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isEarned ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isEarned
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Colors.grey.shade300,
            width: isEarned ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge Icon
              _buildBadgeIcon(context),
              const SizedBox(height: 8),

              // Badge Name
              Text(
                badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isEarned ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),

              // XP Bonus
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isEarned
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${badge.xpBonus} XP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isEarned
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Earned Date or Progress
              if (isEarned)
                _buildEarnedDate()
              else
                _buildProgressIndicator(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEarned
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.grey.shade200,
      ),
      child: ColorFiltered(
        colorFilter: isEarned
            ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
            : const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 1, 0,
              ]),
        child: Center(
          child: _getBadgeIconWidget(context),
        ),
      ),
    );
  }

  Widget _getBadgeIconWidget(BuildContext context) {
    // If we have a URL, we would use Image.network
    // For now, using category-based icons
    IconData iconData;
    switch (badge.category) {
      case BadgeCategory.streak:
        iconData = Icons.local_fire_department;
        break;
      case BadgeCategory.level:
        iconData = Icons.emoji_events;
        break;
      case BadgeCategory.conversation:
        iconData = Icons.chat_bubble;
        break;
      case BadgeCategory.vocabulary:
        iconData = Icons.book;
        break;
      default:
        iconData = Icons.stars;
    }

    return Icon(
      iconData,
      size: 32,
      color: isEarned
          ? Theme.of(context).colorScheme.primary
          : Colors.grey.shade400,
    );
  }

  Widget _buildEarnedDate() {
    if (badge.earnedAt == null) return const SizedBox.shrink();

    final formattedDate = DateFormat('MMM d, y').format(badge.earnedAt!);
    return Text(
      formattedDate,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final progress = badge.progress ?? 0.0;
    final percentage = (progress * 100).toInt();

    return Column(
      children: [
        SizedBox(
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
