import { Injectable } from '@nestjs/common';
import { User, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { UserStatsDto } from './dto/user-stats.dto';

@Injectable()
export class UserRepository {
  constructor(private prisma: PrismaService) {}

  async findById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id },
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { email },
    });
  }

  async update(id: string, data: Prisma.UserUpdateInput): Promise<User> {
    return this.prisma.user.update({
      where: { id },
      data,
    });
  }

  async delete(id: string): Promise<User> {
    return this.prisma.user.delete({
      where: { id },
    });
  }

  async getStats(userId: string): Promise<UserStatsDto> {
    // Calculate date boundaries for "this week"
    const now = new Date();
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay()); // Start of current week (Sunday)
    startOfWeek.setHours(0, 0, 0, 0);

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Parallel queries for efficiency
    const [user, streak, conversationStats, vocabularyStats, pronunciationData] =
      await Promise.all([
        // Get user XP data
        this.prisma.user.findUnique({
          where: { id: userId },
          select: { totalXp: true, level: true },
        }),

        // Get streak data
        this.prisma.streak.findUnique({
          where: { userId },
          select: {
            currentStreak: true,
            longestStreak: true,
            freezeRemaining: true,
          },
        }),

        // Get conversation statistics
        this.prisma.conversation.aggregate({
          where: { userId },
          _count: { id: true },
          _avg: { durationSeconds: true },
        }),

        // Get vocabulary statistics
        this.prisma.vocabulary.aggregate({
          where: { userId },
          _count: { id: true },
        }),

        // Get pronunciation scores for trend analysis
        this.prisma.conversation.findMany({
          where: {
            userId,
            pronunciationScore: { not: null },
          },
          select: {
            pronunciationScore: true,
            startedAt: true,
          },
          orderBy: { startedAt: 'desc' },
          take: 10, // Last 10 conversations with pronunciation scores
        }),
      ]);

    // Get conversation stats for this week
    const conversationsThisWeek = await this.prisma.conversation.count({
      where: {
        userId,
        startedAt: { gte: startOfWeek },
      },
    });

    // Get XP earned this week (sum of xpEarned from conversations this week)
    const xpThisWeek = await this.prisma.conversation.aggregate({
      where: {
        userId,
        startedAt: { gte: startOfWeek },
      },
      _sum: { xpEarned: true },
    });

    // Get vocabulary items due for review today
    const vocabularyDueForReview = await this.prisma.vocabulary.count({
      where: {
        userId,
        nextReviewDate: { lte: today },
      },
    });

    // Calculate pronunciation trend
    let pronunciationTrend: 'up' | 'down' | 'stable' = 'stable';
    let averagePronunciationScore = 0;

    if (pronunciationData.length > 0) {
      // Calculate average pronunciation score
      const totalScore = pronunciationData.reduce(
        (sum, conv) => sum + (conv.pronunciationScore || 0),
        0,
      );
      averagePronunciationScore = totalScore / pronunciationData.length;

      // Calculate trend: compare recent 5 vs previous 5
      if (pronunciationData.length >= 6) {
        const recent5 = pronunciationData.slice(0, 5);
        const previous5 = pronunciationData.slice(5, 10);

        const recentAvg =
          recent5.reduce((sum, c) => sum + (c.pronunciationScore || 0), 0) /
          recent5.length;
        const previousAvg =
          previous5.reduce((sum, c) => sum + (c.pronunciationScore || 0), 0) /
          previous5.length;

        if (recentAvg > previousAvg + 2) {
          pronunciationTrend = 'up';
        } else if (recentAvg < previousAvg - 2) {
          pronunciationTrend = 'down';
        }
      }
    }

    // Map level enum to number (for XP stats)
    const levelMap = {
      BEGINNER: 1,
      ELEMENTARY: 2,
      INTERMEDIATE: 3,
      UPPER_INTERMEDIATE: 4,
      ADVANCED: 5,
    };

    return {
      streak: {
        current: streak?.currentStreak || 0,
        longest: streak?.longestStreak || 0,
        freezeRemaining: streak?.freezeRemaining || 0,
      },
      xp: {
        total: user?.totalXp || 0,
        thisWeek: xpThisWeek._sum.xpEarned || 0,
        level: user?.level ? levelMap[user.level] : 1,
      },
      conversations: {
        total: conversationStats._count.id || 0,
        thisWeek: conversationsThisWeek,
        averageDuration: Math.round(conversationStats._avg.durationSeconds || 0),
      },
      pronunciation: {
        averageScore: Math.round(averagePronunciationScore),
        trend: pronunciationTrend,
      },
      vocabulary: {
        total: vocabularyStats._count.id || 0,
        dueForReview: vocabularyDueForReview,
      },
    };
  }
}
