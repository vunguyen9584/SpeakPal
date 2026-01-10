import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/subscription/providers/subscription_provider.dart';
import 'package:mobile/features/subscription/widgets/subscription_status_widget.dart';
import 'dart:async';

void main() {
  group('SubscriptionStatusWidget Tests', () {
    final mockFreeSubscription = SubscriptionInfo(
      plan: 'free',
      status: 'active',
      expiresAt: null,
      autoRenewing: false,
      features: {},
    );

    final mockPremiumSubscription = SubscriptionInfo(
      plan: 'premium',
      status: 'active',
      expiresAt: DateTime(2026, 12, 31),
      autoRenewing: true,
      features: {},
    );

    final mockUsage = UsageInfo(
      dailyConversations: 2,
      dailyConversationsLimit: 3,
      dailyVocabulary: 35,
      dailyVocabularyLimit: 50,
      nextResetTime: DateTime.now().add(const Duration(hours: 8)),
    );

    final mockUsageLimitReached = UsageInfo(
      dailyConversations: 3,
      dailyConversationsLimit: 3,
      dailyVocabulary: 50,
      dailyVocabularyLimit: 50,
      nextResetTime: DateTime.now().add(const Duration(hours: 8)),
    );

    testWidgets('displays loading indicator while fetching data',
        (WidgetTester tester) async {
      final subCompleter = Completer<SubscriptionInfo>();
      final usageCompleter = Completer<UsageInfo>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith((ref) => subCompleter.future),
            usageProvider.overrideWith((ref) => usageCompleter.future),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
      
      // Cleanup
      subCompleter.complete(mockFreeSubscription);
      usageCompleter.complete(mockUsage);
      await tester.pump(); // Trigger rebuild
      await tester.pump(); // Finish animations if any
    });

    testWidgets('displays free plan information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockFreeSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Free Plan'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    testWidgets('displays premium plan information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockPremiumSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Premium'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('Expires: 31/12/2026'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    testWidgets('displays usage statistics correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockFreeSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Daily Usage'), findsOneWidget);
      expect(find.text('Conversations'), findsOneWidget);
      expect(find.text('Vocabulary'), findsOneWidget);
      expect(find.text('2 / 3'), findsOneWidget);
      expect(find.text('35 / 50'), findsOneWidget);
    });

    testWidgets('displays progress bars correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockFreeSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    });

    testWidgets('shows limit reached warning when usage is at limit',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockFreeSubscription),
            ),
            usageProvider.overrideWith(
              (ref) => Future.value(mockUsageLimitReached),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Daily limit reached'), findsNWidgets(2));
    });

    testWidgets('displays reset time information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockFreeSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.textContaining('Resets in'), findsOneWidget);
    });

    testWidgets('shows upgrade button for free plan',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockFreeSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Upgrade to Premium'), findsOneWidget);
      expect(find.byIcon(Icons.upgrade), findsOneWidget);
    });

    testWidgets('shows manage button for premium plan',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockPremiumSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Manage Subscription'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('displays error state when loading fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.error('Network error'),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to load subscription info'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('upgrade button triggers snackbar when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionProvider.overrideWith(
              (ref) => Future.value(mockFreeSubscription),
            ),
            usageProvider.overrideWith((ref) => Future.value(mockUsage)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SubscriptionStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Upgrade to Premium'));
      await tester.pumpAndSettle();

      expect(find.text('Navigate to plans screen'), findsOneWidget);
    });
  });
}
