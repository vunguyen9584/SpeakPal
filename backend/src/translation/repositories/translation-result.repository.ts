import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { TranslationResult, PracticeType } from '@prisma/client';

@Injectable()
export class TranslationResultRepository {
  private readonly logger = new Logger(TranslationResultRepository.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Create a new translation result
   */
  async create(data: {
    userId: string;
    practiceType: PracticeType;
    questionId?: string;
    userAnswer: string;
    totalScore: number;
    grammarScore?: number;
    vocabScore?: number;
    speedScore?: number;
    intentScore?: number;
    responseTimeSec?: number;
    feedback?: unknown;
    xpEarned: number;
  }): Promise<TranslationResult> {
    const { feedback, ...rest } = data;
    return this.prisma.translationResult.create({
      data: {
        ...rest,
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
        feedback: feedback as any,
      },
    });
  }

  /**
   * Get daily count of translation practice for a user
   * Used for enforcing daily limits based on subscription plan
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

    return this.prisma.translationResult.count({
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
   * Get recent results for streak calculation
   * Returns results from last N days
   */
  async getRecentResults(
    userId: string,
    practiceType: PracticeType,
    days: number = 7,
  ): Promise<TranslationResult[]> {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    return this.prisma.translationResult.findMany({
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

  /**
   * Get user's translation practice history
   */
  async getUserHistory(
    userId: string,
    practiceType?: PracticeType,
    limit: number = 20,
  ): Promise<TranslationResult[]> {
    return this.prisma.translationResult.findMany({
      where: {
        userId,
        ...(practiceType && { practiceType }),
      },
      orderBy: {
        createdAt: 'desc',
      },
      take: limit,
      include: {
        question: true,
      },
    });
  }
}
