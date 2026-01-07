import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import 'package:mobile/features/auth/domain/models/auth_tokens.dart';

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
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Join SpeakPal'), findsOneWidget);
    
    // Find text fields (Email, Username, Password, Confirm Password)
    // RegisterForm usually has these fields.
    // We try to find by hints or labels if possible.
    await tester.enterText(find.byType(TextFormField).at(0), 'newuser@example.com');
    // Assuming 2nd field is username (optional) or password depending on form.
    // Let's assume Username, Password, ConfirmPassword
    await tester.enterText(find.byType(TextFormField).at(1), 'newuser');
    await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
    await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
    
    // Tap register button
    // We look for a button with text 'Register' or 'Sign Up'
    // Let's guess 'Register' based on typical naming
    final registerButtonFinder = find.text('Register');
    if (findsOneWidget.matches(registerButtonFinder, {})) {
       await tester.tap(registerButtonFinder);
    } else {
       // Fallback or generic find if we can't be sure of text
       await tester.tap(find.byType(ElevatedButton).last);
    }
    
    await tester.pump();

    // Verify register was called
    expect(mockRepo.registerCalled, isTrue);
    expect(mockRepo.lastEmail, 'newuser@example.com');
  });
}
