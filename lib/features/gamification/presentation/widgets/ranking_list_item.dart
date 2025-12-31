import 'package:flutter/material.dart';
import '../../domain/models/ranking.dart';

/// Individual ranking list item widget
class RankingListItem extends StatelessWidget {
  final RankingEntry entry;
  final RankZone? zone;
  final bool isTopThree;

  const RankingListItem({
    super.key,
    required this.entry,
    this.zone,
    this.isTopThree = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(context),
          width: entry.isCurrentUser ? 2 : 1,
        ),
        boxShadow: entry.isCurrentUser
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildRankBadge(context),
            const SizedBox(width: 12),
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: _buildUserInfo(context),
            ),
            _buildXpDisplay(context),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (entry.isCurrentUser) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.05);
    }
    if (zone != null) {
      switch (zone!) {
        case RankZone.promotion:
          return Colors.green.shade50;
        case RankZone.demotion:
          return Colors.red.shade50;
        case RankZone.safe:
          return Colors.white;
      }
    }
    return Colors.white;
  }

  Color _getBorderColor(BuildContext context) {
    if (entry.isCurrentUser) {
      return Theme.of(context).colorScheme.primary;
    }
    if (zone != null) {
      switch (zone!) {
        case RankZone.promotion:
          return Colors.green.shade200;
        case RankZone.demotion:
          return Colors.red.shade200;
        case RankZone.safe:
          return Colors.grey.shade200;
      }
    }
    return Colors.grey.shade200;
  }

  Widget _buildRankBadge(BuildContext context) {
    if (isTopThree) {
      return _buildMedalBadge(context);
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '#${entry.rank}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: entry.isCurrentUser ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildMedalBadge(BuildContext context) {
    Color medalColor;
    IconData medalIcon;

    switch (entry.rank) {
      case 1:
        medalColor = const Color(0xFFFFD700); // Gold
        medalIcon = Icons.emoji_events;
        break;
      case 2:
        medalColor = const Color(0xFFC0C0C0); // Silver
        medalIcon = Icons.emoji_events;
        break;
      case 3:
        medalColor = const Color(0xFFCD7F32); // Bronze
        medalIcon = Icons.emoji_events;
        break;
      default:
        medalColor = Colors.grey;
        medalIcon = Icons.emoji_events;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: medalColor.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: medalColor, width: 2),
      ),
      child: Icon(
        medalIcon,
        color: medalColor,
        size: 24,
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade300,
      backgroundImage:
          entry.avatarUrl != null ? NetworkImage(entry.avatarUrl!) : null,
      child: entry.avatarUrl == null
          ? Text(
              entry.userName.isNotEmpty ? entry.userName[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                entry.userName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: entry.isCurrentUser
                      ? FontWeight.bold
                      : FontWeight.w600,
                  color: entry.isCurrentUser
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (entry.isCurrentUser) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'YOU',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        _buildLeagueBadge(context),
      ],
    );
  }

  Widget _buildLeagueBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getLeagueColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _getLeagueColor(),
          width: 1,
        ),
      ),
      child: Text(
        entry.league.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _getLeagueColor(),
        ),
      ),
    );
  }

  Color _getLeagueColor() {
    return Color(int.parse(entry.league.color.replaceFirst('#', '0xFF')));
  }

  Widget _buildXpDisplay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${entry.weeklyXp}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: entry.isCurrentUser
                ? Theme.of(context).colorScheme.primary
                : Colors.black87,
          ),
        ),
        Text(
          'XP',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
