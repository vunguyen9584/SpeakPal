import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Content types that can be gated by subscription
enum ContentType {
  shadowingBasic,
  shadowingAdvanced,
  wordAssociation,
  advancedTranslation,
  conversation,
  vocabulary,
}

/// Provider for subscription information
final subscriptionProvider = FutureProvider<SubscriptionInfo>((ref) async {
  // TODO(backend): Replace with actual API call to GET /api/subscription/current
  // Priority: HIGH - Required for subscription features
  // See: docs/BACKEND_INTEGRATION_CHECKLIST.md#1-subscription-management-api
  await Future.delayed(const Duration(milliseconds: 500));
  return SubscriptionInfo(
    plan: 'free',
    status: 'active',
    expiresAt: null,
    autoRenewing: false,
    features: {
      'dailyConversations': 3,
      'dailyVocabulary': 50,
      'aiModels': ['basic'],
      'offlineMode': false,
      'adFree': false,
    },
  );
});

/// Provider to check if user has access to specific content type
final hasContentAccessProvider = Provider.family<bool, ContentType>((ref, contentType) {
  final subscriptionAsync = ref.watch(subscriptionProvider);
  
  return subscriptionAsync.when(
    data: (subscription) {
      // Free content is always accessible
      if (contentType == ContentType.shadowingBasic ||
          contentType == ContentType.conversation ||
          contentType == ContentType.vocabulary) {
        return true;
      }
      
      // Premium content requires premium subscription
      return subscription.isPremium && subscription.isActive;
    },
    loading: () => false, // Default to locked while loading
    error: (e, _) => false, // Default to locked on error
  );
});

/// Provider for usage information
final usageProvider = FutureProvider<UsageInfo>((ref) async {
  // TODO(backend): Replace with actual API call to GET /api/subscription/usage
  // Priority: HIGH - Required for usage tracking
  // See: docs/BACKEND_INTEGRATION_CHECKLIST.md#get-apisubscriptionusage
  await Future.delayed(const Duration(milliseconds: 500));
  return UsageInfo(
    dailyConversations: 2,
    dailyConversationsLimit: 3,
    dailyVocabulary: 35,
    dailyVocabularyLimit: 50,
    nextResetTime: DateTime.now().add(const Duration(hours: 8)),
  );
});

/// Provider for available plans
final plansProvider = FutureProvider<List<PlanInfo>>((ref) async {
  // TODO(backend): Replace with actual API call to GET /api/subscription/plans
  // Priority: MEDIUM - Required for subscription screen
  // See: docs/BACKEND_INTEGRATION_CHECKLIST.md#get-apisubscriptionplans
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    PlanInfo(
      id: 'free',
      name: 'Free',
      price: '\$0',
      features: [
        '3 conversations per day',
        '50 vocabulary words per day',
        'Basic AI model',
        'Community support',
      ],
      isPopular: false,
    ),
    PlanInfo(
      id: 'premium_monthly',
      name: 'Premium Monthly',
      price: '\$9.99/month',
      features: [
        'Unlimited conversations',
        'Unlimited vocabulary',
        'Advanced AI models',
        'Offline mode',
        'Ad-free experience',
        'Priority support',
        'Custom learning paths',
        'Detailed analytics',
      ],
      isPopular: true,
    ),
    PlanInfo(
      id: 'premium_yearly',
      name: 'Premium Yearly',
      price: '\$99.99/year',
      features: [
        'All Premium Monthly features',
        'Save 17% compared to monthly',
        'Exclusive yearly content',
        'Early access to new features',
      ],
      isPopular: false,
    ),
  ];
});

/// Subscription information model
class SubscriptionInfo {
  final String plan; // free, premium
  final String status; // active, expired, cancelled
  final DateTime? expiresAt;
  final bool autoRenewing;
  final Map<String, dynamic> features;

  SubscriptionInfo({
    required this.plan,
    required this.status,
    this.expiresAt,
    required this.autoRenewing,
    required this.features,
  });

  bool get isPremium => plan.contains('premium');
  bool get isActive => status == 'active';
}

/// Usage information model
class UsageInfo {
  final int dailyConversations;
  final int dailyConversationsLimit;
  final int dailyVocabulary;
  final int dailyVocabularyLimit;
  final DateTime nextResetTime;

  UsageInfo({
    required this.dailyConversations,
    required this.dailyConversationsLimit,
    required this.dailyVocabulary,
    required this.dailyVocabularyLimit,
    required this.nextResetTime,
  });

  double get conversationsProgress =>
      dailyConversations / dailyConversationsLimit;
  double get vocabularyProgress => dailyVocabulary / dailyVocabularyLimit;

  bool get conversationsLimitReached =>
      dailyConversations >= dailyConversationsLimit;
  bool get vocabularyLimitReached => dailyVocabulary >= dailyVocabularyLimit;
}

/// Plan information model
class PlanInfo {
  final String id;
  final String name;
  final String price;
  final List<String> features;
  final bool isPopular;

  PlanInfo({
    required this.id,
    required this.name,
    required this.price,
    required this.features,
    required this.isPopular,
  });

  bool get isFree => id == 'free';
}

