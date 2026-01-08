import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { StreakResponseDto } from './dto/streak-response.dto';

const STREAK_MILESTONES = [7, 30, 100];

@Injectable()
export class StreakService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Record user activity and update streak
   */
  async recordActivity(userId: string): Promise<StreakResponseDto> {
    // Get or create streak record
    let streak = await this.prisma.streak.findUnique({
      where: { userId },
    });

    if (!streak) {
      // Create initial streak
      streak = await this.prisma.streak.create({
        data: {
          userId,
          currentStreak: 1,
          longestStreak: 1,
          freezeRemaining: 0,
          lastActivityDate: new Date(),
        },
      });
      return this.getStreakStatus(userId);
    }

    const today = this.getToday();
    const yesterday = this.getYesterday();
    const lastActivity = streak.lastActivityDate
      ? this.stripTime(streak.lastActivityDate)
      : null;

    let newStreak = streak.currentStreak;

    // Already recorded activity today
    if (lastActivity && lastActivity.getTime() === today.getTime()) {
      return this.getStreakStatus(userId);
    }

    // Yesterday active → increment streak
    if (lastActivity && lastActivity.getTime() === yesterday.getTime()) {
      newStreak = streak.currentStreak + 1;
    }
    // Gap exists
    else if (lastActivity && lastActivity.getTime() < yesterday.getTime()) {
      // Try to use freeze
      if (streak.freezeRemaining > 0) {
        // Use freeze, maintain streak
        await this.prisma.streak.update({
          where: { userId },
          data: {
            freezeRemaining: streak.freezeRemaining - 1,
          },
        });
      } else {
        // No freeze, reset streak
        newStreak = 1;
      }
    }
    // First time or no previous activity
    else {
      newStreak = 1;
    }

    // Update streak
    const longestStreak = Math.max(streak.longestStreak, newStreak);

    await this.prisma.streak.update({
      where: { userId },
      data: {
        currentStreak: newStreak,
        longestStreak,
        lastActivityDate: new Date(),
      },
    });

    // Check for streak badges
    this.checkStreakBadges(userId, newStreak);

    return this.getStreakStatus(userId);
  }

  /**
   * Get current streak status
   */
  async getStreakStatus(userId: string): Promise<StreakResponseDto> {
    let streak = await this.prisma.streak.findUnique({
      where: { userId },
    });

    if (!streak) {
      // Create initial streak if not exists
      streak = await this.prisma.streak.create({
        data: {
          userId,
          currentStreak: 0,
          longestStreak: 0,
          freezeRemaining: 0,
        },
      });
    }

    const nextMilestone = this.getNextMilestone(streak.currentStreak);
    const daysUntilMilestone = nextMilestone - streak.currentStreak;

    return {
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      freezeRemaining: streak.freezeRemaining,
      lastActivityDate: streak.lastActivityDate,
      nextMilestone,
      daysUntilMilestone,
    };
  }

  /**
   * Use streak freeze
   */
  async useFreeze(
    userId: string,
  ): Promise<{ success: boolean; message: string }> {
    const streak = await this.prisma.streak.findUnique({
      where: { userId },
    });

    if (!streak) {
      throw new Error('Streak not found');
    }

    if (streak.freezeRemaining <= 0) {
      throw new BadRequestException('No streak freezes available');
    }

    await this.prisma.streak.update({
      where: { userId },
      data: {
        freezeRemaining: streak.freezeRemaining - 1,
      },
    });

    return {
      success: true,
      message: 'Streak freeze used successfully',
    };
  }

  /**
   * Award streak freeze (e.g., from premium subscription or achievements)
   */
  async awardFreeze(userId: string, count: number = 1): Promise<void> {
    // Get or create streak
    const streak = await this.prisma.streak.findUnique({
      where: { userId },
    });

    if (!streak) {
      await this.prisma.streak.create({
        data: {
          userId,
          currentStreak: 0,
          longestStreak: 0,
          freezeRemaining: count,
        },
      });
    } else {
      await this.prisma.streak.update({
        where: { userId },
        data: {
          freezeRemaining: {
            increment: count,
          },
        },
      });
    }
  }

  /**
   * Check and award streak badges
   */
  private checkStreakBadges(userId: string, streak: number): void {
    // Check for milestone badges (7, 30, 100 days)
    const badgeCodes = [];
    if (streak >= 7) badgeCodes.push('STREAK_7');
    if (streak >= 30) badgeCodes.push('STREAK_30');
    if (streak >= 100) badgeCodes.push('STREAK_100');

    // TODO: Award badges (integrate with BadgeService)
    // For now, just log
    if (badgeCodes.length > 0) {
      console.log(
        `User ${userId} eligible for badges: ${badgeCodes.join(', ')}`,
      );
    }
  }

  /**
   * Get next milestone
   */
  private getNextMilestone(currentStreak: number): number {
    for (const milestone of STREAK_MILESTONES) {
      if (currentStreak < milestone) {
        return milestone;
      }
    }
    return STREAK_MILESTONES[STREAK_MILESTONES.length - 1];
  }

  /**
   * Get today's date with time stripped
   */
  private getToday(): Date {
    return this.stripTime(new Date());
  }

  /**
   * Get yesterday's date
   */
  private getYesterday(): Date {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    return this.stripTime(yesterday);
  }

  /**
   * Strip time from date
   */
  private stripTime(date: Date): Date {
    const stripped = new Date(date);
    stripped.setHours(0, 0, 0, 0);
    return stripped;
  }
}
