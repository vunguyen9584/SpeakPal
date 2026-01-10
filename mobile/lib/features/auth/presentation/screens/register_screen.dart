import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/router/routes.dart';
import 'package:mobile/config/theme/typography.dart';
import '../../../../config/theme/spacing.dart';
import '../providers/auth_provider.dart';
import '../../domain/models/auth_state.dart';
import '../widgets/register_form.dart';
import '../widgets/social_login_buttons.dart';

/// Register Screen
class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) {
          // Navigate to onboarding after successful registration
          context.go('/onboarding');
        },
        error: (message) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
        orElse: () {},
      );
    });

    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Welcome Text
              Text(
                'Join SpeakPal',
                style: AppTypography.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Start your language learning journey',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Register Form
              RegisterForm(
                isLoading: isLoading,
                onRegister: (email, password, username) {
                  ref.read(authStateProvider.notifier).register(
                        email,
                        password,
                        username,
                      );
                },
                onLogin: () {
                  context.go(AppRoutes.login);
                },
              ),
              const SizedBox(height: 24),

              // Social Login Buttons
              SocialLoginButtons(
                isLoading: isLoading,
                onGoogleSignIn: () {
                  ref.read(authStateProvider.notifier).loginWithGoogle();
                },
                onAppleSignIn: () {
                  ref.read(authStateProvider.notifier).loginWithApple();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

