import { Injectable, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { PlanService, PLAN_FEATURES } from './plan.service';
import { UsageResponseDto } from './dto/usage-response.dto';

export type UsageType = 'conversation' | 'vocabulary';

export const PLAN_LIMITS = {
    free: {
        conversation: 3,
        vocabulary: 50,
    },
    premium: {
        conversation: -1, // Unlimited
        vocabulary: -1, // Unlimited
    },
};

@Injectable()
export class UsageService {
    constructor(
        private readonly prisma: PrismaService,
        private readonly planService: PlanService,
    ) { }

    /**
     * Check and increment usage for a specific type
     * Throws ForbiddenException if limit is reached
     */
    async checkAndIncrementUsage(
        userId: string,
        type: UsageType,
    ): Promise<boolean> {
        const plan = await this.planService.getCurrentPlan(userId);
        const limit = PLAN_LIMITS[plan][type];

        // Unlimited access
        if (limit === -1) {
            await this.incrementUsage(userId, type);
            return true;
        }

        const today = this.getStartOfDayUTC();
        const usage = await this.getUsageCount(userId, type, today);

        if (usage >= limit) {
            throw new ForbiddenException(
                `Daily ${type} limit reached. Upgrade to premium for unlimited access.`,
            );
        }

        await this.incrementUsage(userId, type);
        return true;
    }

    /**
     * Get current usage status for all types
     */
    async getUsageStatus(userId: string): Promise<{
        conversations: UsageResponseDto;
        vocabulary: { used: number; limit: number };
    }> {
        const plan = await this.planService.getCurrentPlan(userId);
        const today = this.getStartOfDayUTC();

        const conversationUsage = await this.getUsageCount(
            userId,
            'conversation',
            today,
        );
        const vocabularyUsage = await this.getUsageCount(
            userId,
            'vocabulary',
            today,
        );

        return {
            conversations: UsageResponseDto.create(
                conversationUsage,
                PLAN_LIMITS[plan].conversation,
            ),
            vocabulary: {
                used: vocabularyUsage,
                limit: PLAN_LIMITS[plan].vocabulary,
            },
        };
    }

    /**
     * Get usage count for a specific type and date
     */
    private async getUsageCount(
        userId: string,
        type: UsageType,
        date: Date,
    ): Promise<number> {
        const usage = await this.prisma.dailyUsage.findUnique({
            where: {
                userId_date_type: {
                    userId,
                    date,
                    type,
                },
            },
        });

        return usage?.count || 0;
    }

    /**
     * Increment usage count
     */
    private async incrementUsage(userId: string, type: UsageType): Promise<void> {
        const today = this.getStartOfDayUTC();

        await this.prisma.dailyUsage.upsert({
            where: {
                userId_date_type: {
                    userId,
                    date: today,
                    type,
                },
            },
            create: {
                userId,
                date: today,
                type,
                count: 1,
            },
            update: {
                count: {
                    increment: 1,
                },
            },
        });
    }

    /**
     * Reset daily usage (called by cron job at midnight UTC)
     */
    async resetDailyUsage(): Promise<void> {
        const yesterday = new Date();
        yesterday.setUTCDate(yesterday.getUTCDate() - 1);
        yesterday.setUTCHours(0, 0, 0, 0);

        // Delete old usage records (keep last 7 days for analytics)
        const sevenDaysAgo = new Date();
        sevenDaysAgo.setUTCDate(sevenDaysAgo.getUTCDate() - 7);
        sevenDaysAgo.setUTCHours(0, 0, 0, 0);

        await this.prisma.dailyUsage.deleteMany({
            where: {
                date: {
                    lt: sevenDaysAgo,
                },
            },
        });
    }

    /**
     * Get start of day in UTC
     */
    private getStartOfDayUTC(): Date {
        const now = new Date();
        return new Date(
            Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 0, 0, 0, 0),
        );
    }
}
