import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../domain/models/badge.dart';

/// Modal displaying detailed information about a badge
class BadgeDetailModal extends StatelessWidget {
  final Badge badge;

  const BadgeDetailModal({
    super.key,
    required this.badge,
  });

  bool get isEarned => badge.earnedAt != null;

  static void show(BuildContext context, Badge badge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BadgeDetailModal(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDragHandle(),
                  const SizedBox(height: 24),
                  _buildBadgeIcon(context),
                  const SizedBox(height: 24),
                  _buildBadgeName(context),
                  const SizedBox(height: 8),
                  _buildDescription(context),
                  const SizedBox(height: 24),
                  _buildXpBonus(context),
                  const SizedBox(height: 24),
                  _buildCondition(context),
                  const SizedBox(height: 24),
                  if (isEarned) ...[
                    _buildEarnedInfo(context),
                    const SizedBox(height: 24),
                    _buildShareButton(context),
                  ] else ...[
                    _buildProgressSection(context),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildBadgeIcon(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEarned
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.grey.shade200,
        boxShadow: isEarned
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]
            : null,
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
      size: 64,
      color: isEarned
          ? Theme.of(context).colorScheme.primary
          : Colors.grey.shade400,
    );
  }

  Widget _buildBadgeName(BuildContext context) {
    return Text(
      badge.name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isEarned ? Colors.black87 : Colors.grey.shade600,
          ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      badge.description,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade700,
          ),
    );
  }

  Widget _buildXpBonus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isEarned
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEarned
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars,
            color: isEarned
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade600,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            '+${badge.xpBonus} XP Bonus',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isEarned
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCondition(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'How to Earn',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            badge.conditionDescription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnedInfo(BuildContext context) {
    if (badge.earnedAt == null) return const SizedBox.shrink();

    final formattedDate = DateFormat('MMMM d, y').format(badge.earnedAt!);
    final daysAgo = DateTime.now().difference(badge.earnedAt!).inDays;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Earned on $formattedDate',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          if (daysAgo > 0)
            Text(
              '$daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final progress = badge.progress ?? 0.0;
    final percentage = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.orange.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange.shade600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep going! You\'re ${100 - percentage}% away from earning this badge.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _onSharePressed(context),
        icon: const Icon(Icons.share),
        label: const Text('Share Achievement'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _onSharePressed(BuildContext context) {
    final shareText = 'I just earned the "${badge.name}" badge in SpeakPal! '
        '🎉 (+${badge.xpBonus} XP)';

    Share.share(
      shareText,
      subject: 'SpeakPal Achievement',
    );
  }
}
