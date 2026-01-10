import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/subscription/providers/subscription_provider.dart';

void main() {
  group('Subscription Models Tests', () {
    test('SubscriptionInfo getters work correctly', () {
      final sub = SubscriptionInfo(
        plan: 'premium_monthly',
        status: 'active',
        autoRenewing: true,
        features: {},
      );

      expect(sub.isPremium, true);
      expect(sub.isActive, true);

      final free = SubscriptionInfo(
        plan: 'free',
        status: 'expired',
        autoRenewing: false,
        features: {},
      );

      expect(free.isPremium, false);
      expect(free.isActive, false);
    });

    test('UsageInfo progress and limits work correctly', () {
      final usage = UsageInfo(
        dailyConversations: 2,
        dailyConversationsLimit: 4,
        dailyVocabulary: 50,
        dailyVocabularyLimit: 50,
        nextResetTime: DateTime.now(),
      );

      expect(usage.conversationsProgress, 0.5);
      expect(usage.vocabularyProgress, 1.0);
      expect(usage.conversationsLimitReached, false);
      expect(usage.vocabularyLimitReached, true);
    });

    test('PlanInfo isFree getter works', () {
      final free = PlanInfo(id: 'free', name: 'Free', price: '0', features: [], isPopular: false);
      final paid = PlanInfo(id: 'monthly', name: 'Paid', price: '10', features: [], isPopular: true);

      expect(free.isFree, true);
      expect(paid.isFree, false);
    });
  });
}
