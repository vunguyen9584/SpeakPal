import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../../common/prisma/prisma.service';
import { StreakResponseDto } from './dto/streak-response.dto';

const STREAK_MILESTONES = [7, 30, 100];

@Injectable()
export class StreakService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Record user activity and update streak
   */
  async recordActivity(userId: string): Promise<StreakResponseDto> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    const today = this.getToday();
    const yesterday = this.getYesterday();
    const lastActivity = user.lastActivityDate
      ? this.stripTime(user.lastActivityDate)
      : null;

    let newStreak = user.currentStreak;

    // Already recorded activity today
    if (lastActivity && lastActivity.getTime() === today.getTime()) {
      return this.getStreakStatus(userId);
    }

    // Yesterday active → increment streak
    if (lastActivity && lastActivity.getTime() === yesterday.getTime()) {
      newStreak = user.currentStreak + 1;
    }
    // Gap exists
    else if (lastActivity && lastActivity.getTime() < yesterday.getTime()) {
      // Try to use freeze
      if (user.streakFreezeCount > 0) {
        // Use freeze, maintain streak
        await this.prisma.user.update({
          where: { id: userId },
          data: {
            streakFreezeCount: user.streakFreezeCount - 1,
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
    const longestStreak = Math.max(user.longestStreak, newStreak);

    await this.prisma.user.update({
      where: { id: userId },
      data: {
        currentStreak: newStreak,
        longestStreak,
        lastActivityDate: new Date(),
      },
    });

    // Check for streak badges
    await this.checkStreakBadges(userId, newStreak);

    return this.getStreakStatus(userId);
  }

  /**
   * Get current streak status
   */
  async getStreakStatus(userId: string): Promise<StreakResponseDto> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    const nextMilestone = this.getNextMilestone(user.currentStreak);
    const daysUntilMilestone = nextMilestone - user.currentStreak;

    return {
      currentStreak: user.currentStreak,
      longestStreak: user.longestStreak,
      freezeRemaining: user.streakFreezeCount,
      lastActivityDate: user.lastActivityDate,
      nextMilestone,
      daysUntilMilestone,
    };
  }

  /**
   * Use streak freeze
   */
  async useFreeze(userId: string): Promise<{ success: boolean; message: string }> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    if (user.streakFreezeCount <= 0) {
      throw new BadRequestException('No streak freezes available');
    }

    await this.prisma.user.update({
      where: { id: userId },
      data: {
        streakFreezeCount: user.streakFreezeCount - 1,
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
    await this.prisma.user.update({
      where: { id: userId },
      data: {
        streakFreezeCount: {
          increment: count,
        },
      },
    });
  }

  /**
   * Check and award streak badges
   */
  private async checkStreakBadges(userId: string, streak: number): Promise<void> {
    // Check for milestone badges (7, 30, 100 days)
    const badgeCodes = [];
    if (streak >= 7) badgeCodes.push('STREAK_7');
    if (streak >= 30) badgeCodes.push('STREAK_30');
    if (streak >= 100) badgeCodes.push('STREAK_100');

    // TODO: Award badges (integrate with BadgeService)
    // For now, just log
    if (badgeCodes.length > 0) {
      console.log(`User ${userId} eligible for badges: ${badgeCodes.join(', ')}`);
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

