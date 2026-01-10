import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/theme/typography.dart';
import '../../../../config/theme/spacing.dart';
import '../providers/auth_provider.dart';
import '../../domain/models/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_buttons.dart';

/// Login Screen
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) {
          // Navigate to home on successful login
          context.go('/home');
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo placeholder
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.school,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Welcome Text
              Text(
                'Welcome Back!',
                style: AppTypography.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue practicing',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Login Form
              LoginForm(
                isLoading: isLoading,
                onLogin: (email, password) {
                  ref.read(authStateProvider.notifier).login(email, password);
                },
                onForgotPassword: () {
                  context.push('/auth/forgot-password');
                },
                onRegister: () {
                  context.push('/auth/register');
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

