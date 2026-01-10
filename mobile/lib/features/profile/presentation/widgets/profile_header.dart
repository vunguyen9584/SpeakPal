import 'package:flutter/material.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import 'package:mobile/config/theme/colors.dart';

/// Profile Header Widget
class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  String _getLeagueName(League league) {
    switch (league) {
      case League.bronze:
        return 'Bronze';
      case League.silver:
        return 'Silver';
      case League.gold:
        return 'Gold';
      case League.platinum:
        return 'Platinum';
      case League.diamond:
        return 'Diamond';
    }
  }

  Color _getLeagueColor(League league) {
    switch (league) {
      case League.bronze:
        return const Color(0xFFCD7F32);
      case League.silver:
        return const Color(0xFFC0C0C0);
      case League.gold:
        return const Color(0xFFFFD700);
      case League.platinum:
        return const Color(0xFFE5E4E2);
      case League.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            // League Badge
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getLeagueColor(user.league),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.emoji_events,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Name
        Text(
          user.username ?? user.email.split('@')[0],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),

        // Email
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),

        // League
        Chip(
          label: Text(
            _getLeagueName(user.league),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: _getLeagueColor(user.league),
        ),
      ],
    );
  }
}
