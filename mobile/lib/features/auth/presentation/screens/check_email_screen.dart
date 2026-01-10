import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/typography.dart';
import '../../../../config/theme/spacing.dart';
import '../../../../shared/widgets/app_button.dart';

/// Check Email Screen - Shown after forgot password request
class CheckEmailScreen extends StatelessWidget {
  final String email;

  const CheckEmailScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Your Email'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Check Your Email',
                style: AppTypography.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'We\'ve sent a password reset link to:',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Click the link in the email to reset your password. If you don\'t see the email, check your spam folder.',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // Resend Email Button
              AppButton(
                text: 'Resend Email',
                variant: ButtonVariant.secondary,
                onPressed: () {
                  // TODO: Implement resend logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email resent successfully'),
                    ),
                  );
                },
                isFullWidth: true,
              ),
              const SizedBox(height: 12),

              // Back to Login
              AppButton(
                text: 'Back to Login',
                variant: ButtonVariant.text,
                onPressed: () => context.go('/auth/login'),
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
