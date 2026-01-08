import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/subscription/providers/subscription_provider.dart';
import 'package:mobile/features/subscription/screens/plans_screen.dart';

void main() {
  group('PlansScreen Widget Tests', () {
    final mockPlans = [
      PlanInfo(
        id: 'free',
        name: 'Free',
        price: '\$0',
        features: ['3 conversations per day', '50 vocabulary words per day'],
        isPopular: false,
      ),
      PlanInfo(
        id: 'premium_monthly',
        name: 'Premium Monthly',
        price: '\$9.99/month',
        features: ['Unlimited conversations', 'Unlimited vocabulary'],
        isPopular: true,
      ),
      PlanInfo(
        id: 'premium_yearly',
        name: 'Premium Yearly',
        price: '\$99.99/year',
        features: ['All Premium Monthly features', 'Save 17%'],
        isPopular: false,
      ),
    ];

    final mockSubscription = SubscriptionInfo(
      plan: 'free',
      status: 'active',
      expiresAt: null,
      autoRenewing: false,
      features: {},
    );

    testWidgets('displays loading indicator while fetching plans',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith(
              (ref) => Future.delayed(
                const Duration(seconds: 1),
                () => mockPlans,
              ),
            ),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays plan cards when plans are loaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Premium Monthly'), findsOneWidget);
      expect(find.text('\$9.99/month'), findsOneWidget);
    });

    testWidgets('displays header with title and description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Unlock Your Full Potential'), findsOneWidget);
      expect(find.text('Choose the plan that fits your learning journey'),
          findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    testWidgets('monthly/yearly toggle works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially shows monthly
      expect(find.text('Premium Monthly'), findsOneWidget);

      // Tap yearly toggle
      await tester.tap(find.text('Yearly (Save 17%)'));
      await tester.pumpAndSettle();

      // Should show yearly plan
      expect(find.text('Premium Yearly'), findsOneWidget);
      expect(find.text('\$99.99/year'), findsOneWidget);
    });

    testWidgets('popular badge is displayed on popular plan',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('MOST POPULAR'), findsOneWidget);
    });

    testWidgets('current plan badge is displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Current'), findsOneWidget);
    });

    testWidgets('subscribe button is visible for non-current plans',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Subscribe Now'), findsOneWidget);
    });

    testWidgets('features comparison table is displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Why Go Premium?'), findsOneWidget);
      expect(find.text('Daily Conversations'), findsOneWidget);
      expect(find.text('Vocabulary Practice'), findsOneWidget);
      expect(find.text('AI Models'), findsOneWidget);
    });

    testWidgets('displays error state when loading fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith(
              (ref) => Future.error('Network error'),
            ),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to load plans'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('subscribe button shows dialog when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansProvider.overrideWith((ref) => Future.value(mockPlans)),
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockSubscription),
            ),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap subscribe button
      await tester.tap(find.text('Subscribe Now'));
      await tester.pumpAndSettle();

      expect(find.text('Subscribe'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });
  });
}
