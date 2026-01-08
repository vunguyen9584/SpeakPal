import { SubscriptionPlan, Subscription } from '@prisma/client';

export class SubscriptionResponseDto {
  plan: 'free' | 'premium';
  status: 'active' | 'expired' | 'cancelled';
  expiresAt: Date | null;
  autoRenewing: boolean;
  features: {
    dailyConversations: number;
    unlimitedVocabulary: boolean;
    prioritySupport: boolean;
    noAds: boolean;
    allPersonas: boolean;
  };

  static fromEntity(subscription: Subscription): SubscriptionResponseDto {
    const dto = new SubscriptionResponseDto();
    // Convert Prisma enum to lowercase string
    dto.plan = subscription?.plan
      ? subscription.plan === SubscriptionPlan.PREMIUM
        ? 'premium'
        : 'free'
      : 'free';
    dto.status =
      (subscription?.status as 'active' | 'expired' | 'cancelled') || 'active';
    dto.expiresAt = subscription?.expiresAt || null;
    dto.autoRenewing = subscription?.autoRenewing || false;

    // Set features based on plan
    if (dto.plan === 'premium') {
      dto.features = {
        dailyConversations: -1, // Unlimited
        unlimitedVocabulary: true,
        prioritySupport: true,
        noAds: true,
        allPersonas: true,
      };
    } else {
      dto.features = {
        dailyConversations: 3,
        unlimitedVocabulary: false,
        prioritySupport: false,
        noAds: false,
        allPersonas: false,
      };
    }

    return dto;
  }
}
