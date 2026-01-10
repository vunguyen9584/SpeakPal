import 'package:flutter/material.dart';

/// Onboarding Page Model
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'Practice Conversation with AI',
      description: 'Have natural conversations with AI tutors tailored to your level',
      icon: Icons.chat_bubble_outline,
      color: Colors.blue,
    ),
    OnboardingPageData(
      title: 'Get Instant Feedback',
      description: 'Receive real-time corrections and suggestions to improve your English',
      icon: Icons.auto_fix_high,
      color: Colors.green,
    ),
    OnboardingPageData(
      title: 'Track Your Progress',
      description: 'Monitor your learning journey with detailed statistics and achievements',
      icon: Icons.trending_up,
      color: Colors.orange,
    ),
    OnboardingPageData(
      title: 'Start Your Journey',
      description: 'Join thousands of learners improving their English every day',
      icon: Icons.rocket_launch,
      color: Colors.purple,
    ),
  ];
}

