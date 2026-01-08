import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { SubscriptionResponseDto } from './dto/subscription-response.dto';
import { SubscriptionPlan as PrismaSubscriptionPlan } from '@prisma/client';

export type SubscriptionPlan = 'free' | 'premium';

export const PLAN_FEATURES = {
  free: {
    dailyConversations: 3,
    unlimitedVocabulary: false,
    allPersonas: false,
    prioritySupport: false,
    noAds: false,
  },
  premium: {
    dailyConversations: -1, // Unlimited
    unlimitedVocabulary: true,
    allPersonas: true,
    prioritySupport: true,
    noAds: true,
  },
};

@Injectable()
export class PlanService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Get current plan for a user
   */
  async getCurrentPlan(userId: string): Promise<SubscriptionPlan> {
    const subscription = await this.prisma.subscription.findUnique({
      where: { userId },
    });

    // Check if subscription is active and not expired
    if (
      subscription &&
      subscription.plan === PrismaSubscriptionPlan.PREMIUM &&
      subscription.status === 'active' &&
      (!subscription.expiresAt || subscription.expiresAt > new Date())
    ) {
      return 'premium';
    }

    return 'free';
  }

  /**
   * Get subscription details
   */
  async getSubscription(userId: string): Promise<SubscriptionResponseDto> {
    const subscription = await this.prisma.subscription.findUnique({
      where: { userId },
    });

    return SubscriptionResponseDto.fromEntity(subscription);
  }

  /**
   * Check if user has access to a specific feature
   */
  async checkFeatureAccess(
    userId: string,
    feature: keyof typeof PLAN_FEATURES.free,
  ): Promise<boolean> {
    const plan = await this.getCurrentPlan(userId);
    const featureValue = PLAN_FEATURES[plan][feature];

    if (typeof featureValue === 'boolean') {
      return featureValue;
    }

    // For numeric features like dailyConversations, -1 means unlimited
    return featureValue === -1 || featureValue > 0;
  }

  /**
   * Get plan features
   */
  getPlanFeatures(plan: SubscriptionPlan) {
    return PLAN_FEATURES[plan];
  }

  /**
   * Get free plan (default)
   */
  getFreePlan() {
    return 'free' as SubscriptionPlan;
  }
}
