import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { StatsResponseDto } from '../dto/stats-response.dto';

@Injectable()
export class StatsService {
  constructor(private readonly prisma: PrismaService) {}

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
}
