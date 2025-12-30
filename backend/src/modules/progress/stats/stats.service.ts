import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { StatsResponseDto } from '../dto/stats-response.dto';

@Injectable()
export class StatsService {
  constructor(private readonly prisma: PrismaService) {}

  async getUserStats(userId: string): Promise<StatsResponseDto> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });

    const daily = await this.getDailyStats(userId);
    const weekly = await this.getWeeklyStats(userId);
    const monthly = await this.getMonthlyStats(userId);
    const allTime = await this.getAllTimeStats(userId);

    return {
      daily,
      weekly,
      monthly,
      allTime,
      averagePronunciation: 0, // TODO: Calculate from conversations
      currentStreak: user?.currentStreak || 0,
    };
  }

  private async getDailyStats(userId: string) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const conversations = await this.prisma.conversation.count({
      where: { userId, createdAt: { gte: today } },
    });

    return {
      conversations,
      minutes: 0, // TODO: Sum from conversations
      xp: 0, // TODO: Sum from XPHistory
      vocabulary: 0, // TODO: Count reviews
    };
  }

  private async getWeeklyStats(userId: string) {
    const weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);

    const conversations = await this.prisma.conversation.count({
      where: { userId, createdAt: { gte: weekAgo } },
    });

    return {
      conversations,
      minutes: 0,
      xp: 0,
      vocabulary: 0,
    };
  }

  private async getMonthlyStats(userId: string) {
    const monthAgo = new Date();
    monthAgo.setMonth(monthAgo.getMonth() - 1);

    const conversations = await this.prisma.conversation.count({
      where: { userId, createdAt: { gte: monthAgo } },
    });

    return {
      conversations,
      minutes: 0,
      xp: 0,
      vocabulary: 0,
    };
  }

  private async getAllTimeStats(userId: string) {
    const totalConversations = await this.prisma.conversation.count({
      where: { userId },
    });

    const user = await this.prisma.user.findUnique({ where: { id: userId } });

    return {
      totalConversations,
      totalMinutes: user?.totalMinutesPracticed || 0,
      totalXp: user?.totalXp || 0,
    };
  }
}

