import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/subscription/providers/subscription_provider.dart';

void main() {
  group('Subscription Providers Tests', () {
    test('subscriptionProvider returns data', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(subscriptionProvider.future);
      expect(result.plan, 'free');
    });

    test('usageProvider returns data', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(usageProvider.future);
      expect(result.dailyConversations, 2);
    });

    test('plansProvider returns list of plans', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(plansProvider.future);
      expect(result.length, 3);
      expect(result.first.name, 'Free');
    });
  });
}
