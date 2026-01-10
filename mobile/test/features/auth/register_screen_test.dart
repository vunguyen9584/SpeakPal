import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import 'package:mobile/features/auth/domain/models/auth_tokens.dart';
import 'package:mobile/shared/widgets/app_button.dart';

// Mock AuthRepository
class MockAuthRepository implements AuthRepository {
  bool registerCalled = false;
  String? lastEmail;
  String? lastPassword;
  String? lastUsername;

  @override
  Future<User> register(String email, String password, String? username) async {
    registerCalled = true;
    lastEmail = email;
    lastPassword = password;
    lastUsername = username;
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
  Future<User> login(String email, String password) async {
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
  testWidgets('RegisterScreen renders and triggers registration', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const RegisterScreen()),
              GoRoute(path: '/onboarding', builder: (context, state) => const Scaffold(body: Text('Onboarding'))),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.text('Join SpeakPal'), findsOneWidget);
    
    // Find text fields (Email, Username, Password, Confirm Password)
    // RegisterForm usually has these fields.
    // We try to find by hints or labels if possible.
    await tester.enterText(find.byKey(const Key('regEmailField')), 'newuser@example.com');
    await tester.enterText(find.byKey(const Key('regUsernameField')), 'newuser');
    await tester.enterText(find.byKey(const Key('regPasswordField')), 'Password123!');
    await tester.enterText(find.byKey(const Key('regConfirmPasswordField')), 'Password123!');
    await tester.pump();
    
    // Accept terms
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    
    // Tap register button
    // We look for a button with text 'Register' or 'Sign Up'
    // Tap register button
    final registerButtonFinder = find.byType(AppButton);
    await tester.ensureVisible(registerButtonFinder);
    await tester.tap(registerButtonFinder);
    
    await tester.pumpAndSettle();

    // Verify register was called
    expect(mockRepo.registerCalled, isTrue);
    expect(mockRepo.lastEmail, 'newuser@example.com');
    // Verify we navigated to onboarding
    expect(find.text('Onboarding'), findsOneWidget);
  });
}
