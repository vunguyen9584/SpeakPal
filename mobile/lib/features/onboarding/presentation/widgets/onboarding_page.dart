import 'package:flutter/material.dart';
import '../../domain/onboarding_page_data.dart';

/// Single Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final OnboardingPageData pageData;

  const OnboardingPage({
    super.key,
    required this.pageData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: pageData.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              pageData.icon,
              size: 60,
              color: pageData.color,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            pageData.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            pageData.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

