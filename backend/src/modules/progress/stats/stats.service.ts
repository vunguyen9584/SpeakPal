import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { StatsResponseDto } from '../dto/stats-response.dto';

@Injectable()
export class StatsService {
  constructor(private readonly prisma: PrismaService) { }

  async getUserStats(userId: string): Promise<StatsResponseDto> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    const streak = await this.prisma.streak.findUnique({ where: { userId } });

    const daily = await this.getDailyStats(userId);
    const weekly = await this.getWeeklyStats(userId);
    const monthly = await this.getMonthlyStats(userId);
    const allTime = await this.getAllTimeStats(userId);

    return {
      daily,
      weekly,
      monthly,
      allTime,
      averagePronunciation: 0, // TODO: Calculate from conversation results
      currentStreak: streak?.currentStreak || 0,
    };
  }

  private async getDailyStats(userId: string) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const conversations = await this.prisma.conversation.count({
      where: { userId, startedAt: { gte: today } },
    });

    // Sum duration
    const duration = await this.prisma.conversation.aggregate({
      _sum: { durationSeconds: true },
      where: { userId, startedAt: { gte: today } },
    });

    return {
      conversations,
      minutes: Math.ceil((duration._sum.durationSeconds || 0) / 60),
      xp: 0, // TODO: Need mechanism to track daily XP (DailyUsage table?)
      vocabulary: 0,
    };
  }

  private async getWeeklyStats(userId: string) {
    const weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);

    const conversations = await this.prisma.conversation.count({
      where: { userId, startedAt: { gte: weekAgo } },
    });

    const duration = await this.prisma.conversation.aggregate({
      _sum: { durationSeconds: true },
      where: { userId, startedAt: { gte: weekAgo } },
    });

    return {
      conversations,
      minutes: Math.ceil((duration._sum.durationSeconds || 0) / 60),
      xp: 0,
      vocabulary: 0,
    };
  }

  private async getMonthlyStats(userId: string) {
    const monthAgo = new Date();
    monthAgo.setMonth(monthAgo.getMonth() - 1);

    const conversations = await this.prisma.conversation.count({
      where: { userId, startedAt: { gte: monthAgo } },
    });

    const duration = await this.prisma.conversation.aggregate({
      _sum: { durationSeconds: true },
      where: { userId, startedAt: { gte: monthAgo } },
    });

    return {
      conversations,
      minutes: Math.ceil((duration._sum.durationSeconds || 0) / 60),
      xp: 0,
      vocabulary: 0,
    };
  }

  private async getAllTimeStats(userId: string) {
    const totalConversations = await this.prisma.conversation.count({
      where: { userId },
    });

    const user = await this.prisma.user.findUnique({ where: { id: userId } });

    // Sum all duration
    const duration = await this.prisma.conversation.aggregate({
      _sum: { durationSeconds: true },
      where: { userId },
    });

    return {
      totalConversations,
      totalMinutes: Math.ceil((duration._sum.durationSeconds || 0) / 60),
      totalXp: user?.totalXp || 0,
    };
  }

  /**
   * Get weekly progress report
   */
  async getWeeklyReport(userId: string, weekOffset: number = 0) {
    const now = new Date();
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay() - weekOffset * 7);
    startOfWeek.setHours(0, 0, 0, 0);

    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    endOfWeek.setHours(23, 59, 59, 999);

    // Get conversations in this week
    const conversations = await this.prisma.conversation.findMany({
      where: {
        userId,
        startedAt: { gte: startOfWeek, lte: endOfWeek },
      },
      select: {
        startedAt: true,
        durationSeconds: true,
      },
    });

    // Calculate daily breakdown
    const dailyBreakdown = [];
    for (let i = 0; i < 7; i++) {
      const date = new Date(startOfWeek);
      date.setDate(startOfWeek.getDate() + i);
      const dateStr = date.toISOString().split('T')[0];

      const dayConversations = conversations.filter((c) => {
        const convDate = new Date(c.startedAt);
        return convDate.toISOString().split('T')[0] === dateStr;
      });

      dailyBreakdown.push({
        date: dateStr,
        xp: dayConversations.length * 10, // 10 XP per conversation
        minutes: Math.ceil(
          dayConversations.reduce((sum, c) => sum + (c.durationSeconds || 0), 0) / 60,
        ),
        conversations: dayConversations.length,
      });
    }

    const totalXP = dailyBreakdown.reduce((sum, day) => sum + day.xp, 0);
    const totalMinutes = dailyBreakdown.reduce((sum, day) => sum + day.minutes, 0);

    // Get vocabulary learned this week
    const vocabularyCount = await this.prisma.vocabulary.count({
      where: {
        userId,
        createdAt: { gte: startOfWeek, lte: endOfWeek },
      },
    });

    return {
      weekNumber: Math.ceil((now.getTime() - startOfWeek.getTime()) / (7 * 24 * 60 * 60 * 1000)),
      startDate: startOfWeek.toISOString().split('T')[0],
      endDate: endOfWeek.toISOString().split('T')[0],
      totalXP,
      totalMinutes,
      conversationsCompleted: conversations.length,
      vocabularyLearned: vocabularyCount,
      averageScore: 85, // TODO: Calculate from actual scores
      dailyBreakdown,
    };
  }

  /**
   * Get monthly progress report
   */
  async getMonthlyReport(userId: string, monthOffset: number = 0) {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth() - monthOffset, 1);
    const endOfMonth = new Date(now.getFullYear(), now.getMonth() - monthOffset + 1, 0, 23, 59, 59, 999);

    // Get conversations in this month
    const conversations = await this.prisma.conversation.findMany({
      where: {
        userId,
        startedAt: { gte: startOfMonth, lte: endOfMonth },
      },
      select: {
        startedAt: true,
        durationSeconds: true,
      },
    });

    // Calculate daily breakdown
    const dailyBreakdown = [];
    const daysInMonth = endOfMonth.getDate();

    for (let i = 1; i <= daysInMonth; i++) {
      const date = new Date(startOfMonth.getFullYear(), startOfMonth.getMonth(), i);
      const dateStr = date.toISOString().split('T')[0];

      const dayConversations = conversations.filter((c) => {
        const convDate = new Date(c.startedAt);
        return convDate.toISOString().split('T')[0] === dateStr;
      });

      dailyBreakdown.push({
        date: dateStr,
        xp: dayConversations.length * 10,
        minutes: Math.ceil(
          dayConversations.reduce((sum, c) => sum + (c.durationSeconds || 0), 0) / 60,
        ),
        conversations: dayConversations.length,
      });
    }

    const totalXP = dailyBreakdown.reduce((sum, day) => sum + day.xp, 0);
    const totalMinutes = dailyBreakdown.reduce((sum, day) => sum + day.minutes, 0);

    // Get vocabulary learned this month
    const vocabularyCount = await this.prisma.vocabulary.count({
      where: {
        userId,
        createdAt: { gte: startOfMonth, lte: endOfMonth },
      },
    });

    return {
      monthNumber: startOfMonth.getMonth() + 1,
      year: startOfMonth.getFullYear(),
      startDate: startOfMonth.toISOString().split('T')[0],
      endDate: endOfMonth.toISOString().split('T')[0],
      totalXP,
      totalMinutes,
      conversationsCompleted: conversations.length,
      vocabularyLearned: vocabularyCount,
      averageScore: 85, // TODO: Calculate from actual scores
      dailyBreakdown,
    };
  }

  /**
   * Get learning history with pagination
   */
  async getLearningHistory(
    userId: string,
    page: number = 1,
    limit: number = 20,
    type?: 'conversation' | 'vocabulary' | 'shadowing' | 'all',
  ) {
    const skip = (page - 1) * limit;
    const items = [];

    // Get conversations
    if (!type || type === 'all' || type === 'conversation') {
      const conversations = await this.prisma.conversation.findMany({
        where: { userId },
        orderBy: { startedAt: 'desc' },
        take: limit,
        skip,
      });

      items.push(
        ...conversations.map((c) => ({
          id: c.id,
          type: 'conversation' as const,
          title: `Conversation - ${c.topic || c.mode}`,
          completedAt: c.startedAt.toISOString(),
          score: c.pronunciationScore || 85,
          xpEarned: c.xpEarned || 10,
          duration: c.durationSeconds || 0,
        })),
      );
    }

    // Get vocabulary
    if (!type || type === 'all' || type === 'vocabulary') {
      const vocabulary = await this.prisma.vocabulary.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
        take: limit,
        skip,
        select: {
          id: true,
          word: true,
          createdAt: true,
        },
      });

      items.push(
        ...vocabulary.map((v) => ({
          id: v.id,
          type: 'vocabulary' as const,
          title: `Learned: ${v.word}`,
          completedAt: v.createdAt.toISOString(),
          score: 100,
          xpEarned: 5,
          duration: 0,
        })),
      );
    }

    // Sort by completedAt
    items.sort((a, b) => new Date(b.completedAt).getTime() - new Date(a.completedAt).getTime());

    // Get total count
    const totalConversations = await this.prisma.conversation.count({ where: { userId } });
    const totalVocabulary = await this.prisma.vocabulary.count({ where: { userId } });
    const total = type === 'conversation' ? totalConversations : type === 'vocabulary' ? totalVocabulary : totalConversations + totalVocabulary;

    return {
      items: items.slice(0, limit),
      total,
      page,
      totalPages: Math.ceil(total / limit),
    };
  }
}
