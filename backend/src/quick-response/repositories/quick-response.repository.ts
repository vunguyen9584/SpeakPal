import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { QuickResponseResult, PracticeType } from '@prisma/client';

@Injectable()
export class QuickResponseRepository {
  private readonly logger = new Logger(QuickResponseRepository.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Create a new quick response result
   */
  async create(data: {
    userId: string;
    practiceType: PracticeType;
    sessionId?: string;
    contentId?: string;
    totalScore: number;
    correctCount?: number;
    maxChain?: number;
    followingScore?: number;
    pronunciationScore?: number;
    rhythmScore?: number;
    durationSec?: number;
    details?: any;
    xpEarned: number;
  }): Promise<QuickResponseResult> {
    return this.prisma.quickResponseResult.create({
      data,
    });
  }

  /**
   * Get daily count for quick response practice
   */
  async getDailyCount(
    userId: string,
    practiceType: PracticeType,
    date: Date = new Date(),
  ): Promise<number> {
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);

    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    return this.prisma.quickResponseResult.count({
      where: {
        userId,
        practiceType,
        createdAt: {
          gte: startOfDay,
          lte: endOfDay,
        },
      },
    });
  }

  /**
   * Get user's quick response history
   */
  async getUserHistory(
    userId: string,
    practiceType?: PracticeType,
    limit: number = 20,
  ): Promise<QuickResponseResult[]> {
    return this.prisma.quickResponseResult.findMany({
      where: {
        userId,
        ...(practiceType && { practiceType }),
      },
      orderBy: {
        createdAt: 'desc',
      },
      take: limit,
    });
  }

  /**
   * Get recent results for streak calculation
   */
  async getRecentResults(
    userId: string,
    practiceType: PracticeType,
    days: number = 7,
  ): Promise<QuickResponseResult[]> {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    return this.prisma.quickResponseResult.findMany({
      where: {
        userId,
        practiceType,
        createdAt: {
          gte: startDate,
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }
}
