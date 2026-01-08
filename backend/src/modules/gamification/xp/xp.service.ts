import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { League } from '@prisma/client';

// Level formula: Level N requires N * 200 XP
// Level 1: 200 XP, Level 5: 1000 XP (cumulative), Level 10: 2000 XP
const XP_PER_LEVEL = 200;

@Injectable()
export class XpService {
  constructor(private readonly prisma: PrismaService) { }

  /**
   * Calculate level from total XP
   */
  calculateLevel(totalXp: number): number {
    return Math.floor(totalXp / XP_PER_LEVEL) + 1;
  }

  /**
   * Calculate XP needed for next level
   */
  xpForNextLevel(currentLevel: number): number {
    return currentLevel * XP_PER_LEVEL;
  }

  /**
   * Calculate progress percentage to next level
   */
  progressToNextLevel(totalXp: number): number {
    const xpInCurrentLevel = totalXp % XP_PER_LEVEL;
    const xpNeeded = XP_PER_LEVEL;
    return Math.floor((xpInCurrentLevel / xpNeeded) * 100);
  }

  /**
   * Add XP to user and check for level up
   */
  async addXP(
    userId: string,
    amount: number,
    source: string,
  ): Promise<{ leveledUp: boolean; newLevel: number; totalXp: number }> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    const oldLevel = this.calculateLevel(user.totalXp);
    const newTotalXp = user.totalXp + amount;
    const newLevel = this.calculateLevel(newTotalXp);
    const leveledUp = newLevel > oldLevel;

    // Update user XP
    // Note: We don't update 'level' column as it is an Enum (CEFR), not the numeric level
    await this.prisma.user.update({
      where: { id: userId },
      data: {
        totalXp: newTotalXp,
      },
      // Note: If we wanted to update CEFR level based on XP, we would do it here
    });

    // Update weekly XP (for rankings)
    await this.updateWeeklyXp(userId, amount);

    // Log XP history - Skipped as XPHistory table doesn't exist in current schema
    // console.log(`[XP] User ${userId} gained ${amount} XP from ${source}`);

    return {
      leveledUp,
      newLevel,
      totalXp: newTotalXp,
    };
  }

  /**
   * Update weekly XP for rankings
   */
  private async updateWeeklyXp(userId: string, amount: number): Promise<void> {
    const weekNumber = this.getCurrentWeekNumber();
    const year = new Date().getFullYear();

    // Check if user has weekly stats for this week
    const existing = await this.prisma.userRanking.findUnique({
      where: {
        userId_weekNumber_year: {
          userId,
          weekNumber,
          year,
        },
      },
    });

    if (existing) {
      await this.prisma.userRanking.update({
        where: { id: existing.id },
        data: {
          weeklyXp: { increment: amount },
        },
      });
    } else {
      // Need user's league
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: { league: true },
      });

      if (user) {
        await this.prisma.userRanking.create({
          data: {
            userId,
            weekNumber,
            year,
            league: user.league,
            weeklyXp: amount,
            rank: 0, // Will be calculated by a background job or triggers
          },
        });
      }
    }
  }

  /**
   * Get current week number (ISO week)
   */
  private getCurrentWeekNumber(): number {
    const now = new Date();
    const onejan = new Date(now.getFullYear(), 0, 1);
    const week = Math.ceil(
      ((now.getTime() - onejan.getTime()) / 86400000 + onejan.getDay() + 1) / 7,
    );
    return week;
  }

  /**
   * Get user's XP stats
   */
  async getUserXpStats(userId: string): Promise<{
    totalXp: number;
    level: number;
    xpToNextLevel: number;
    progressPercent: number;
  }> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    const level = this.calculateLevel(user.totalXp);
    const xpToNextLevel = XP_PER_LEVEL - (user.totalXp % XP_PER_LEVEL);
    const progressPercent = this.progressToNextLevel(user.totalXp);

    return {
      totalXp: user.totalXp,
      level,
      xpToNextLevel,
      progressPercent,
    };
  }
}
