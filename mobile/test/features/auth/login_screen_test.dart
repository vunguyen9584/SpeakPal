import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import 'package:mobile/features/auth/domain/models/auth_tokens.dart';

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
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign in to continue practicing'), findsOneWidget);
    
    // Find text fields
    // Assuming LoginForm uses TextFormField
    final emailFinder = find.widgetWithText(TextFormField, 'Email'); 
    final passwordFinder = find.widgetWithText(TextFormField, 'Password');

    // Note: If labels are not exactly 'Email' or 'Password', we might need generic finder
    // fallback to finding by Type if specific text fails, but let's try finding by type order
    
    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    
    // Tap login button
    // We look for a button with text 'Login'
    final loginButtonFinder = find.text('Login');
    await tester.tap(loginButtonFinder);
    await tester.pump();

    // Verify login was called
    expect(mockRepo.loginCalled, isTrue);
    expect(mockRepo.lastEmail, 'test@example.com');
  });
}
