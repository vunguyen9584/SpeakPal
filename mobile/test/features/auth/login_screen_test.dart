import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import 'package:mobile/features/auth/domain/models/auth_state.dart';
import 'package:mobile/shared/widgets/app_button.dart';
import 'package:mobile/config/router/routes.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(AuthState.initial());
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
  });

  Widget createWidget({List<Override> overrides = const [], GoRouter? router}) {
    final defaultRouter = router ?? GoRouter(
      initialLocation: AppRoutes.login,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(body: Text('Home Screen')),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const Scaffold(body: Text('Forgot Password Screen')),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const Scaffold(body: Text('Register Screen')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
        ...overrides,
      ],
      child: MaterialApp.router(
        routerConfig: defaultRouter,
      ),
    );
  }

  testWidgets('LoginScreen renders initial state', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back!'), findsOneWidget);
  });

  testWidgets('LoginScreen shows error snackbar on error state', (WidgetTester tester) async {
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
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    container.read(authStateProvider.notifier).state = const AuthState.error('Invalid credentials');
    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
    // Allow timer to complete
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('LoginScreen navigates to home on authenticated state', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final user = User(
      id: '1',
      email: 'test@test.com',
      level: Level.beginner,
      totalXp: 0,
      currentLevelXp: 0,
      league: League.bronze,
      aiSpeed: 1.0,
      confirmationMode: true,
      isVerified: true,
      createdAt: DateTime.now(),
    );

    final element = tester.element(find.byType(LoginScreen));
    final container = ProviderScope.containerOf(element);
    container.read(authStateProvider.notifier).state = AuthState.authenticated(user);
    
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('LoginScreen navigates to forgot password', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final forgotLink = find.text('Forgot Password?');
    await tester.ensureVisible(forgotLink);
    await tester.tap(forgotLink);
    await tester.pumpAndSettle();
    expect(find.text('Forgot Password Screen'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('LoginScreen navigates to register', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final registerLink = find.widgetWithText(TextButton, 'Register');
    await tester.ensureVisible(registerLink);
    await tester.tap(registerLink);
    await tester.pumpAndSettle();
    expect(find.text('Register Screen'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('LoginScreen triggers login on form submit', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    final user = User(
      id: '1',
      email: 'test@test.com',
      level: Level.beginner,
      totalXp: 0,
      currentLevelXp: 0,
      league: League.bronze,
      aiSpeed: 1.0,
      confirmationMode: true,
      isVerified: true,
      createdAt: DateTime.now(),
    );

    when(() => mockRepo.login(any(), any())).thenAnswer((_) async => user);

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final emailField = find.byKey(const Key('emailField'));
    final passwordField = find.byKey(const Key('passwordField'));
    final loginButton = find.widgetWithText(AppButton, 'Login');

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();

    verify(() => mockRepo.login('test@example.com', 'password123')).called(1);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('LoginScreen triggers social login', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 3000));
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    
    when(() => mockRepo.loginWithGoogle()).thenAnswer((_) async => throw Exception('Google error'));
    when(() => mockRepo.loginWithApple()).thenAnswer((_) async => throw Exception('Apple error'));

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    // Google login
    final googleBtn = find.widgetWithText(OutlinedButton, 'Continue with Google');
    await tester.ensureVisible(googleBtn);
    await tester.tap(googleBtn);
    await tester.pump(); // Start timer
    verify(() => mockRepo.loginWithGoogle()).called(1);

    // Apple login
    final appleBtn = find.widgetWithText(OutlinedButton, 'Continue with Apple');
    await tester.ensureVisible(appleBtn);
    await tester.tap(appleBtn);
    await tester.pump(); // Start timer
    verify(() => mockRepo.loginWithApple()).called(1);
    
    // Clear timers
    await tester.pump(const Duration(seconds: 3));
    
    debugDefaultTargetPlatformOverride = null;
    await tester.binding.setSurfaceSize(null);
  });
}
