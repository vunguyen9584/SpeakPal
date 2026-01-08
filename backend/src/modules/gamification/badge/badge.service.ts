import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { BADGE_DEFINITIONS } from './badge.constants';
import { BadgeDto, UserBadgeDto } from './dto/badge-response.dto';

@Injectable()
export class BadgeService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Get all badges
   */
  async listAll(): Promise<BadgeDto[]> {
    const badges = await this.prisma.badge.findMany({
      orderBy: { category: 'asc' },
    });

    return badges.map((badge) => ({
      id: badge.id,
      code: badge.code,
      name: badge.name,
      nameJa: badge.nameJa,
      description: badge.description,
      category: badge.category as any,
      xpBonus: badge.xpBonus,
      iconUrl: badge.iconUrl,
      condition: badge.condition as string,
    }));
  }

  /**
   * Get user's earned badges
   */
  async listUserBadges(userId: string): Promise<UserBadgeDto[]> {
    const userBadges = await this.prisma.userBadge.findMany({
      where: { userId },
      include: { badge: true },
      orderBy: { earnedAt: 'desc' },
    });

    return userBadges.map((ub) => ({
      id: ub.id,
      badge: {
        id: ub.badge.id,
        code: ub.badge.code,
        name: ub.badge.name,
        nameJa: ub.badge.nameJa,
        description: ub.badge.description,
        category: ub.badge.category as any,
        xpBonus: ub.badge.xpBonus,
        iconUrl: ub.badge.iconUrl,
        condition: ub.badge.condition as string,
      },
      earnedAt: ub.earnedAt,
    }));
  }

  /**
   * Check if user is eligible for badges and award them
   */
  async checkAndAward(
    userId: string,
    eventType: 'conversation' | 'vocabulary' | 'level' | 'streak' | 'challenge',
  ): Promise<string[]> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return [];
    }

    // Get stats for badge checking
    const stats = await this.getUserStats(userId);
    const earnedBadges: string[] = [];

    // Check each badge definition
    for (const badgeDef of BADGE_DEFINITIONS) {
      // Check if already earned
      const alreadyEarned = await this.prisma.userBadge.findFirst({
        where: {
          userId,
          badge: { code: badgeDef.code },
        },
      });

      if (alreadyEarned) continue;

      // Check condition
      const eligible = this.checkCondition(badgeDef.condition, stats);

      if (eligible) {
        await this.awardBadge(userId, badgeDef.code);
        earnedBadges.push(badgeDef.code);
      }
    }

    return earnedBadges;
  }

  /**
   * Award a specific badge to user
   */
  async awardBadge(userId: string, badgeCode: string): Promise<void> {
    const badge = await this.prisma.badge.findUnique({
      where: { code: badgeCode },
    });

    if (!badge) {
      console.error(`Badge ${badgeCode} not found`);
      return;
    }

    // Check if already awarded
    const existing = await this.prisma.userBadge.findFirst({
      where: {
        userId,
        badgeId: badge.id,
      },
    });

    if (existing) {
      return;
    }

    // Award badge
    await this.prisma.userBadge.create({
      data: {
        userId,
        badgeId: badge.id,
      },
    });

    // Award XP bonus
    // TODO: Integrate with XpService
    console.log(`Awarded ${badge.xpBonus} XP for badge ${badgeCode}`);

    // TODO: Send notification
  }

  /**
   * Get badge progress for a user
   */
  async getProgress(
    userId: string,
    badgeCode: string,
  ): Promise<{
    current: number;
    target: number;
    percent: number;
  }> {
    const badge = await this.prisma.badge.findUnique({
      where: { code: badgeCode },
    });

    if (!badge) {
      throw new Error('Badge not found');
    }

    const stats = await this.getUserStats(userId);

    // Parse condition to get target value
    // e.g., "currentStreak >= 7" -> target = 7
    const match = (badge.condition as string).match(/>=\s*(\d+)/);
    const target = match ? parseInt(match[1]) : 100;

    // Get current value based on condition
    let current = 0;
    const conditionStr = badge.condition as string;
    if (conditionStr.includes('currentStreak')) {
      current = stats.currentStreak;
    } else if (conditionStr.includes('level')) {
      current = stats.level;
    } else if (conditionStr.includes('conversationCount')) {
      current = stats.conversationCount;
    } else if (conditionStr.includes('vocabularyCount')) {
      current = stats.vocabularyCount;
    }

    const percent = Math.min(Math.floor((current / target) * 100), 100);

    return { current, target, percent };
  }

  /**
   * Check if a condition is met
   */
  private checkCondition(condition: string, stats: any): boolean {
    try {
      // Simple condition parser
      if (condition.includes('currentStreak >=')) {
        const value = parseInt(condition.match(/>=\s*(\d+)/)?.[1] || '0');
        return stats.currentStreak >= value;
      }
      if (condition.includes('level >=')) {
        const value = parseInt(condition.match(/>=\s*(\d+)/)?.[1] || '0');
        return stats.level >= value;
      }
      if (condition.includes('conversationCount >=')) {
        const value = parseInt(condition.match(/>=\s*(\d+)/)?.[1] || '0');
        return stats.conversationCount >= value;
      }
      if (condition.includes('vocabularyCount >=')) {
        const value = parseInt(condition.match(/>=\s*(\d+)/)?.[1] || '0');
        return stats.vocabularyCount >= value;
      }
      return false;
    } catch (error) {
      console.error('Error checking badge condition:', error);
      return false;
    }
  }

  /**
   * Get user stats for badge checking
   */
  private async getUserStats(userId: string): Promise<any> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: { streak: true },
    });

    if (!user) {
      return {
        currentStreak: 0,
        level: 1,
        conversationCount: 0,
        vocabularyCount: 0,
      };
    }

    const conversationCount = await this.prisma.conversation.count({
      where: { userId },
    });

    const vocabularyCount = await this.prisma.vocabulary.count({
      where: { userId },
    });

    return {
      currentStreak: user.streak?.currentStreak || 0,
      level: user.level,
      conversationCount,
      vocabularyCount,
    };
  }
}
