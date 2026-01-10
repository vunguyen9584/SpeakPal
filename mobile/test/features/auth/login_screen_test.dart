import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import 'package:mobile/features/auth/domain/models/auth_tokens.dart';
import 'package:mobile/shared/widgets/app_button.dart';

// Mock AuthRepository
class MockAuthRepository implements AuthRepository {
  bool loginCalled = false;
  String? lastEmail;
  String? lastPassword;

  @override
  Future<User> login(String email, String password) async {
    loginCalled = true;
    lastEmail = email;
    lastPassword = password;
    return User(
      id: '1', 
      email: email, 
      level: Level.beginner, 
      totalXp: 0, 
      currentLevelXp: 0, 
      league: League.bronze, 
      aiSpeed: 1.0, 
      confirmationMode: true, 
      isVerified: true, 
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<User> register(String email, String password, String? username) async {
     throw UnimplementedError();
  }
  
  @override
  Future<void> logout() async {}
  
  @override
  Future<AuthTokens> refreshTokens() async {
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> resetPassword(String token, String newPassword) async {}

  @override
  Future<User> loginWithGoogle() async { throw UnimplementedError(); }

  @override
  Future<User> loginWithApple() async { throw UnimplementedError(); }

  @override
  Future<User?> getCurrentUser() async {
    return null; // Start unauthenticated
  }

  @override
  Future<bool> isAuthenticated() async {
    return false;
  }
}

void main() {
  testWidgets('LoginScreen renders and triggers login', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
              GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Text('Home'))),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign in to continue practicing'), findsOneWidget);
    
    // Find text fields and enter text
    await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
    await tester.pump();
    
    // Tap login button
    final loginButtonFinder = find.widgetWithText(AppButton, 'Login');
    await tester.ensureVisible(loginButtonFinder);
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();

    // Verify login was called
    expect(mockRepo.loginCalled, isTrue, reason: 'Repository login should have been called');
    expect(mockRepo.lastEmail, 'test@example.com', reason: 'Email passed to repository should match');
    
    // Verify we navigated to home
    expect(find.text('Home'), findsOneWidget, reason: 'Should have navigated to Home screen');
  });
}
