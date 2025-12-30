import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/typography.dart';
import '../../../../config/theme/dimensions.dart';
import '../../../../shared/widgets/app_button.dart';

/// Onboarding Complete Screen
class OnboardingCompleteScreen extends StatelessWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 40),

              // Title
              Text(
                'You\'re All Set!',
                style: AppTypography.h1.copyWith(
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Your AI conversation partner is ready. Start practicing English now!',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Feature List
              _buildFeature(
                Icons.chat_bubble_outline,
                'Practice Conversations',
                'Talk with your AI tutor anytime',
              ),
              const SizedBox(height: 16),
              _buildFeature(
                Icons.auto_fix_high,
                'Get Feedback',
                'Receive instant corrections',
              ),
              const SizedBox(height: 16),
              _buildFeature(
                Icons.emoji_events_outlined,
                'Track Progress',
                'Earn XP and unlock achievements',
              ),
              const SizedBox(height: 48),

              // Start Button
              AppButton(
                text: 'Start Learning',
                onPressed: () {
                  // Navigate to home
                  context.go('/home');
                },
                isFullWidth: true,
                size: ButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
