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

@Injectable()
export class ReportService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Generate weekly report for a specific week
   */
  async generateWeeklyReport(
    userId: string,
    weekNumber: number,
    year?: number,
  ): Promise<WeeklyReportResponseDto> {
    const currentYear = year || new Date().getFullYear();
    const { startDate, endDate } = this.getWeekDateRange(weekNumber, currentYear);

    const summary = await this.aggregateStats(userId, startDate, endDate);
    const pronunciationTrend = await this.getPronunciationTrend(userId, startDate, endDate);
    const topCorrections = await this.getTopCorrections(userId, startDate, endDate);
    const vocabularyProgress = await this.getVocabProgress(userId, startDate, endDate);
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
    const pronunciationTrend = await this.getPronunciationTrend(userId, startDate, endDate);
    const topCorrections = await this.getTopCorrections(userId, startDate, endDate);
    const vocabularyProgress = await this.getVocabProgress(userId, startDate, endDate);
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
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    // Sum practice minutes from conversations
    const conversations = await this.prisma.conversation.findMany({
      where: {
        userId,
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      select: {
        durationSeconds: true,
      },
    });

    const totalMinutes = Math.floor(
      conversations.reduce((sum, conv) => sum + (conv.durationSeconds || 0), 0) / 60,
    );

    // Sum XP from XPHistory
    const xpHistory = await this.prisma.xPHistory.aggregate({
      where: {
        userId,
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      _sum: {
        amount: true,
      },
    });

    const totalXp = xpHistory._sum.amount || 0;

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
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
        pronunciationScore: {
          not: null,
        },
      },
      select: {
        createdAt: true,
        pronunciationScore: true,
      },
      orderBy: {
        createdAt: 'asc',
      },
    });

    // Group by date and calculate average
    const trendMap = new Map<string, { total: number; count: number }>();

    conversations.forEach((conv) => {
      const dateKey = conv.createdAt.toISOString().split('T')[0];
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
    // Query feedback records from conversations
    const feedback = await this.prisma.feedback.findMany({
      where: {
        conversation: {
          userId,
          createdAt: {
            gte: startDate,
            lte: endDate,
          },
        },
      },
      select: {
        corrections: true,
      },
    });

    // Aggregate correction types
    const correctionMap = new Map<string, { count: number; examples: Set<string> }>();

    feedback.forEach((fb) => {
      if (fb.corrections && Array.isArray(fb.corrections)) {
        (fb.corrections as any[]).forEach((correction: any) => {
          const type = correction.type || 'grammar';
          const example = correction.original || '';

          const existing = correctionMap.get(type) || { count: 0, examples: new Set() };
          existing.count += 1;
          if (example && existing.examples.size < 3) {
            existing.examples.add(example);
          }
          correctionMap.set(type, existing);
        });
      }
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

    return topCorrections
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);
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

    // Words that reached mastered status in this period
    const masteredWords = await this.prisma.vocabulary.count({
      where: {
        userId,
        srsLevel: 'mastered',
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

    // Level ups in this period (check XP history for level changes)
    const xpHistory = await this.prisma.xPHistory.findMany({
      where: {
        userId,
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: {
        createdAt: 'asc',
      },
    });

    // Detect level ups by checking when totalXpAfter crosses level boundaries
    // Level N requires N * 200 XP
    let previousLevel = 1;
    xpHistory.forEach((entry) => {
      const currentLevel = Math.floor(entry.totalXpAfter / 200) + 1;
      if (currentLevel > previousLevel) {
        achievements.push({
          type: 'level_up',
          title: `Reached Level ${currentLevel}`,
          description: `You've advanced to level ${currentLevel}!`,
          earnedAt: entry.createdAt,
        });
      }
      previousLevel = currentLevel;
    });

    // Streak milestones (check if user reached 7, 30, 100 days in this period)
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { currentStreak: true, longestStreak: true },
    });

    if (user) {
      const milestones = [7, 30, 100];
      milestones.forEach((milestone) => {
        if (user.currentStreak >= milestone || user.longestStreak >= milestone) {
          // Check if this milestone was likely reached in this period
          // This is a simplified check - in production, you'd track this more precisely
          achievements.push({
            type: 'streak_milestone',
            title: `${milestone} Day Streak`,
            description: `Maintained a ${milestone}-day learning streak!`,
            earnedAt: endDate, // Approximate
          });
        }
      });
    }

    return achievements.slice(0, 10); // Limit to 10 achievements
  }

  /**
   * Get week date range from week number
   */
  private getWeekDateRange(weekNumber: number, year: number): { startDate: Date; endDate: Date } {
    // Calculate the start date of the week
    const janFirst = new Date(year, 0, 1);
    const daysOffset = (weekNumber - 1) * 7;
    const startDate = new Date(janFirst);
    startDate.setDate(janFirst.getDate() + daysOffset);

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
  private getMonthDateRange(month: number, year: number): { startDate: Date; endDate: Date } {
    const startDate = new Date(year, month - 1, 1);
    startDate.setHours(0, 0, 0, 0);

    const endDate = new Date(year, month, 0); // Last day of month
    endDate.setHours(23, 59, 59, 999);

    return { startDate, endDate };
  }
}
