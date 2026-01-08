import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import {
  WeeklyReportResponseDto,
  MonthlyReportResponseDto,
  ReportSummaryDto,
  PronunciationTrendDto,
  TopCorrectionDto,
  VocabularyProgressDto,
  AchievementDto,
} from '../dto/report-response.dto';
import { SrsLevel } from '@prisma/client';

@Injectable()
export class ReportService {
  constructor(private readonly prisma: PrismaService) { }

  /**
   * Generate weekly report for a specific week
   */
  async generateWeeklyReport(
    userId: string,
    weekNumber: number,
    year?: number,
  ): Promise<WeeklyReportResponseDto> {
    const currentYear = year || new Date().getFullYear();
    const { startDate, endDate } = this.getWeekDateRange(
      weekNumber,
      currentYear,
    );

    const summary = await this.aggregateStats(userId, startDate, endDate);
    const pronunciationTrend = await this.getPronunciationTrend(
      userId,
      startDate,
      endDate,
    );
    const topCorrections = await this.getTopCorrections(
      userId,
      startDate,
      endDate,
    );
    const vocabularyProgress = await this.getVocabProgress(
      userId,
      startDate,
      endDate,
    );
    const achievements = await this.getAchievements(userId, startDate, endDate);

    return {
      weekNumber,
      year: currentYear,
      startDate,
      endDate,
      summary,
      pronunciationTrend,
      topCorrections,
      vocabularyProgress,
      achievements,
    };
  }

  /**
   * Generate monthly report for a specific month
   */
  async generateMonthlyReport(
    userId: string,
    month: number,
    year: number,
  ): Promise<MonthlyReportResponseDto> {
    const { startDate, endDate } = this.getMonthDateRange(month, year);

    const summary = await this.aggregateStats(userId, startDate, endDate);
    const pronunciationTrend = await this.getPronunciationTrend(
      userId,
      startDate,
      endDate,
    );
    const topCorrections = await this.getTopCorrections(
      userId,
      startDate,
      endDate,
    );
    const vocabularyProgress = await this.getVocabProgress(
      userId,
      startDate,
      endDate,
    );
    const achievements = await this.getAchievements(userId, startDate, endDate);

    return {
      month,
      year,
      startDate,
      endDate,
      summary,
      pronunciationTrend,
      topCorrections,
      vocabularyProgress,
      achievements,
    };
  }

  /**
   * Aggregate statistics for a date range
   */
  private async aggregateStats(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<ReportSummaryDto> {
    // Count conversations
    const totalConversations = await this.prisma.conversation.count({
      where: {
        userId,
        startedAt: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    // Sum practice minutes from conversations
    const duration = await this.prisma.conversation.aggregate({
      _sum: { durationSeconds: true },
      where: {
        userId,
        startedAt: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    const totalMinutes = Math.floor((duration._sum.durationSeconds || 0) / 60);

    // Sum XP from Conversations (and potentially other sources if queried)
    const xp = await this.prisma.conversation.aggregate({
      _sum: { xpEarned: true },
      where: {
        userId,
        startedAt: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    const totalXp = xp._sum.xpEarned || 0;

    // Count vocabulary reviews (words reviewed in this period)
    const totalVocabularyReviews = await this.prisma.vocabulary.count({
      where: {
        userId,
        updatedAt: {
          gte: startDate,
          lte: endDate,
        },
        reviewCount: {
          gt: 0,
        },
      },
    });

    return {
      totalConversations,
      totalMinutes,
      totalXp,
      totalVocabularyReviews,
    };
  }

  /**
   * Get pronunciation trend (daily averages)
   */
  private async getPronunciationTrend(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<PronunciationTrendDto[]> {
    const conversations = await this.prisma.conversation.findMany({
      where: {
        userId,
        startedAt: {
          gte: startDate,
          lte: endDate,
        },
        pronunciationScore: {
          not: null,
        },
      },
      select: {
        startedAt: true,
        pronunciationScore: true,
      },
      orderBy: {
        startedAt: 'asc',
      },
    });

    // Group by date and calculate average
    const trendMap = new Map<string, { total: number; count: number }>();

    conversations.forEach((conv) => {
      const dateKey = conv.startedAt.toISOString().split('T')[0];
      const existing = trendMap.get(dateKey) || { total: 0, count: 0 };
      existing.total += conv.pronunciationScore || 0;
      existing.count += 1;
      trendMap.set(dateKey, existing);
    });

    const trend: PronunciationTrendDto[] = [];
    trendMap.forEach((value, date) => {
      trend.push({
        date,
        averageScore: Math.round(value.total / value.count),
      });
    });

    return trend.sort((a, b) => a.date.localeCompare(b.date));
  }

  /**
   * Get top 5 correction types
   */
  private async getTopCorrections(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<TopCorrectionDto[]> {
    const corrections = await this.prisma.correction.findMany({
      where: {
        turn: {
          conversation: {
            userId,
            startedAt: {
              gte: startDate,
              lte: endDate,
            },
          },
        },
      },
      include: {
        // We might need context if logic required it, but for now we just count types/examples
      },
    });

    // Aggregate correction types
    const correctionMap = new Map<
      string,
      { count: number; examples: Set<string> }
    >();

    corrections.forEach((c) => {
      const type = c.type.toString(); // CorrectionType is Enum
      const example = c.originalText || '';

      const existing = correctionMap.get(type) || {
        count: 0,
        examples: new Set(),
      };
      existing.count += 1;
      if (example && existing.examples.size < 3) {
        existing.examples.add(example);
      }
      correctionMap.set(type, existing);
    });

    // Convert to array and sort by count
    const topCorrections: TopCorrectionDto[] = [];
    correctionMap.forEach((value, type) => {
      topCorrections.push({
        type,
        count: value.count,
        examples: Array.from(value.examples).slice(0, 3),
      });
    });

    return topCorrections.sort((a, b) => b.count - a.count).slice(0, 5);
  }

  /**
   * Get vocabulary progress (new, reviewed, mastered)
   */
  private async getVocabProgress(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<VocabularyProgressDto> {
    // New words added in this period
    const newWords = await this.prisma.vocabulary.count({
      where: {
        userId,
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    // Words reviewed in this period
    const reviewedWords = await this.prisma.vocabulary.count({
      where: {
        userId,
        updatedAt: {
          gte: startDate,
          lte: endDate,
        },
        reviewCount: {
          gt: 0,
        },
      },
    });

    // Words that reached mastered status
    // Note: This is an approximation (currently mastered, updated in this period)
    const masteredWords = await this.prisma.vocabulary.count({
      where: {
        userId,
        srsLevel: SrsLevel.MASTERED,
        updatedAt: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    return {
      newWords,
      reviewedWords,
      masteredWords,
    };
  }

  /**
   * Get achievements earned in the period
   */
  private async getAchievements(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<AchievementDto[]> {
    const achievements: AchievementDto[] = [];

    // Badges earned in this period
    const badges = await this.prisma.userBadge.findMany({
      where: {
        userId,
        earnedAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      include: {
        badge: true,
      },
      orderBy: {
        earnedAt: 'desc',
      },
    });

    badges.forEach((userBadge) => {
      achievements.push({
        type: 'badge',
        title: userBadge.badge.name,
        description: userBadge.badge.description,
        earnedAt: userBadge.earnedAt,
        iconUrl: userBadge.badge.iconUrl || undefined,
      });
    });

    // Streak milestones (check specific streaks)
    const streak = await this.prisma.streak.findUnique({
      where: { userId },
    });

    if (streak) {
      const milestones = [7, 30, 100];
      milestones.forEach((milestone) => {
        if (
          streak.currentStreak >= milestone ||
          streak.longestStreak >= milestone
        ) {
          // Approximate check
          achievements.push({
            type: 'streak_milestone',
            title: `${milestone} Day Streak`,
            description: `Maintained a ${milestone}-day learning streak!`,
            earnedAt: endDate, // Approximate
          });
        }
      });
    }

    // Dedup by title
    const uniqueAchievements = achievements.filter((val, id, array) => array.findIndex(v => v.title === val.title) === id);

    return uniqueAchievements.slice(0, 10); // Limit to 10 achievements
  }

  /**
   * Get week date range from week number
   */
  private getWeekDateRange(
    weekNumber: number,
    year: number,
  ): { startDate: Date; endDate: Date } {
    // Calculate the start date of the week
    const janFirst = new Date(year, 0, 1);
    const dayOfWeek = janFirst.getDay(); // 0 (Sun) to 6 (Sat)
    // Adjust to get first Monday or Sunday? Assuming ISO week start?
    // Simplified calculation
    const daysOffset = (weekNumber - 1) * 7;
    const startDate = new Date(janFirst);
    startDate.setDate(janFirst.getDate() + daysOffset - dayOfWeek); // Adjust to start of week

    // Set to beginning of day
    startDate.setHours(0, 0, 0, 0);

    // End date is 6 days later
    const endDate = new Date(startDate);
    endDate.setDate(startDate.getDate() + 6);
    endDate.setHours(23, 59, 59, 999);

    return { startDate, endDate };
  }

  /**
   * Get month date range
   */
  private getMonthDateRange(
    month: number,
    year: number,
  ): { startDate: Date; endDate: Date } {
    const startDate = new Date(year, month - 1, 1);
    startDate.setHours(0, 0, 0, 0);

    const endDate = new Date(year, month, 0); // Last day of month
    endDate.setHours(23, 59, 59, 999);

    return { startDate, endDate };
  }
}
