import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import 'package:mobile/features/auth/domain/models/auth_state.dart';
import 'package:mobile/shared/widgets/app_button.dart';
import 'package:mobile/config/router/routes.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/error/app_error.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(AuthState.initial());
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => const Right(null));
  });

  Widget createWidget({List<Override> overrides = const []}) {
    final router = GoRouter(
      initialLocation: AppRoutes.register,
      routes: [
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const Scaffold(body: Text('Onboarding Screen')),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const Scaffold(body: Text('Login Screen')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
        ...overrides,
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('RegisterScreen renders initial state', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();
    expect(find.text('Join SpeakPal'), findsOneWidget);
  });

  testWidgets('RegisterScreen shows error snackbar on error state', (WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    container.read(authStateProvider.notifier).state = const AuthState.error('Registration failed');
    await tester.pump();

    expect(find.text('Registration failed'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('RegisterScreen navigates to onboarding on authenticated state', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final user = User(
      id: '1',
      email: 'new@test.com',
      level: Level.beginner,
      totalXp: 0,
      currentLevelXp: 0,
      league: League.bronze,
      aiSpeed: 1.0,
      confirmationMode: true,
      isVerified: true,
      createdAt: DateTime.now(),
    );

    final element = tester.element(find.byType(RegisterScreen));
    final container = ProviderScope.containerOf(element);
    container.read(authStateProvider.notifier).state = AuthState.authenticated(user);
    
    await tester.pumpAndSettle();

    expect(find.text('Onboarding Screen'), findsOneWidget);
  });

  testWidgets('RegisterScreen navigates to login', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final loginBtn = find.widgetWithText(TextButton, 'Login');
    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();
    expect(find.text('Login Screen'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('RegisterScreen triggers register on form submit', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 3000));
    final user = User(
      id: '1',
      email: 'new@test.com',
      level: Level.beginner,
      totalXp: 0,
      currentLevelXp: 0,
      league: League.bronze,
      aiSpeed: 1.0,
      confirmationMode: true,
      isVerified: true,
      createdAt: DateTime.now(),
    );

    when(() => mockRepo.register(any(), any(), any())).thenAnswer((_) async => Right(user));

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final emailField = find.byKey(const Key('regEmailField'));
    final usernameField = find.byKey(const Key('regUsernameField'));
    final passwordField = find.byKey(const Key('regPasswordField'));
    final confirmPasswordField = find.byKey(const Key('regConfirmPasswordField'));
    final checkbox = find.byType(Checkbox);
    final registerBtn = find.widgetWithText(AppButton, 'Register');

    await tester.enterText(emailField, 'new@example.com');
    await tester.enterText(usernameField, 'tester');
    await tester.enterText(passwordField, 'Password123!');
    await tester.enterText(confirmPasswordField, 'Password123!');
    await tester.pump();
    
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    await tester.ensureVisible(registerBtn);
    await tester.tap(registerBtn);
    await tester.pump();

    verify(() => mockRepo.register('new@example.com', 'Password123!', 'tester')).called(1);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('RegisterScreen triggers social login', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 4000));
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    when(() => mockRepo.loginWithGoogle()).thenAnswer((_) async => const Left(AuthError('Google error')));
    when(() => mockRepo.loginWithApple()).thenAnswer((_) async => const Left(AuthError('Apple error')));

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final googleBtn = find.widgetWithText(OutlinedButton, 'Continue with Google');
    await tester.ensureVisible(googleBtn);
    await tester.tap(googleBtn);
    await tester.pump();
    verify(() => mockRepo.loginWithGoogle()).called(1);

    final appleBtn = find.widgetWithText(OutlinedButton, 'Continue with Apple');
    await tester.ensureVisible(appleBtn);
    await tester.tap(appleBtn);
    await tester.pump();
    verify(() => mockRepo.loginWithApple()).called(1);

    await tester.pump(const Duration(seconds: 3));
    debugDefaultTargetPlatformOverride = null;
    await tester.binding.setSurfaceSize(null);
  });
}
