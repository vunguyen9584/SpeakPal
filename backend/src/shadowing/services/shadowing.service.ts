import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { Level, ContentType, PracticeType } from '@prisma/client';
import { ShadowingContentRepository } from '../repositories';
import { QuickResponseRepository } from '../../quick-response/repositories';

// Daily limits by subscription plan
const DAILY_LIMITS: Record<string, { shadowing: number }> = {
  FREE: { shadowing: 5 },
  PREMIUM: { shadowing: 30 },
  PREMIUM_PLUS: { shadowing: 999999 },
};

@Injectable()
export class ShadowingService {
  private readonly logger = new Logger(ShadowingService.name);

  constructor(
    private readonly contentRepo: ShadowingContentRepository,
    private readonly resultRepo: QuickResponseRepository,
  ) {}

  /**
   * Get shadowing content for practice
   * Implements UC-038: Shadowing Practice
   */
  async getShadowingContent(
    userId: string,
    contentType: ContentType,
    level?: Level,
    userPlan: string = 'FREE',
  ): Promise<any> {
    // 1. Check daily limit
    const dailyCount = await this.resultRepo.getDailyCount(
      userId,
      PracticeType.SHADOWING,
    );
    const limit =
      DAILY_LIMITS[userPlan]?.shadowing || DAILY_LIMITS.FREE.shadowing;

    if (dailyCount >= limit) {
      throw new Error('本日の練習回数上限に達しました (Daily limit reached)');
    }

    // 2. Check if user has premium access
    const isPremiumUser = userPlan !== 'FREE';

    // 3. Get random content
    const userLevel = level || Level.BEGINNER;
    const content = await this.contentRepo.findRandomContent(
      contentType,
      userLevel,
      isPremiumUser,
    );

    if (!content) {
      throw new NotFoundException(
        '利用可能なコンテンツがありません (No content available)',
      );
    }

    // 4. Return content with daily progress
    return {
      id: content.id,
      contentType: content.contentType,
      title: content.title,
      description: content.description,
      level: content.level,
      transcript: content.transcript,
      audioUrl: content.audioUrl,
      timestamps: content.timestamps,
      durationSec: content.durationSec,
      isPremium: content.isPremium,
      thumbnailUrl: content.thumbnailUrl,
      dailyProgress: { completed: dailyCount, limit },
    };
  }

  /**
   * Submit shadowing practice result
   * Analyze audio sync and calculate scores
   */
  async submitResult(
    userId: string,
    contentId: string,
    followingScore: number,
    pronunciationScore: number,
    rhythmScore: number,
    durationSec: number,
    details?: any,
  ): Promise<any> {
    // 1. Verify content exists
    const content = await this.contentRepo.findById(contentId);
    if (!content) {
      throw new NotFoundException(
        'コンテンツが見つかりません (Content not found)',
      );
    }

    // 2. Calculate total score (weighted average)
    const totalScore = Math.round(
      followingScore * 0.4 + pronunciationScore * 0.35 + rhythmScore * 0.25,
    );

    // 3. Calculate XP
    let xpEarned = 25; // Base XP for shadowing
    if (totalScore >= 80) xpEarned += 15;
    if (totalScore >= 90) xpEarned += 10;

    // Check streak
    const streak = await this.getShadowingStreak(userId);
    const streakBonus = totalScore >= 70 && streak >= 3;
    if (streakBonus) xpEarned += 25;

    // 4. Save result
    const result = await this.resultRepo.create({
      userId,
      practiceType: PracticeType.SHADOWING,
      contentId,
      totalScore,
      followingScore,
      pronunciationScore,
      rhythmScore,
      durationSec,
      details,
      xpEarned,
    });

    // 5. Generate feedback
    const feedback = this.generateFeedback(
      followingScore,
      pronunciationScore,
      rhythmScore,
    );

    // 6. Return response
    return {
      id: result.id,
      totalScore,
      followingScore,
      pronunciationScore,
      rhythmScore,
      xpEarned,
      streakBonus,
      feedback,
    };
  }

  /**
   * Get list of shadowing contents
   */
  async getContentList(
    contentType?: ContentType,
    level?: Level,
    isPremium?: boolean,
    limit: number = 20,
  ): Promise<any[]> {
    const contents = await this.contentRepo.findAll({
      contentType,
      level,
      isPremium,
      limit,
    });

    return contents.map((content) => ({
      id: content.id,
      contentType: content.contentType,
      title: content.title,
      description: content.description,
      level: content.level,
      durationSec: content.durationSec,
      isPremium: content.isPremium,
      thumbnailUrl: content.thumbnailUrl,
    }));
  }

  /**
   * Get user's shadowing history
   */
  async getHistory(userId: string, limit: number = 20): Promise<any[]> {
    const results = await this.resultRepo.getUserHistory(
      userId,
      PracticeType.SHADOWING,
      limit,
    );

    return results.map((result) => ({
      id: result.id,
      contentId: result.contentId,
      totalScore: result.totalScore,
      followingScore: result.followingScore,
      pronunciationScore: result.pronunciationScore,
      rhythmScore: result.rhythmScore,
      xpEarned: result.xpEarned,
      createdAt: result.createdAt,
    }));
  }

  /**
   * Get shadowing practice streak
   */
  private async getShadowingStreak(userId: string): Promise<number> {
    const recentResults = await this.resultRepo.getRecentResults(
      userId,
      PracticeType.SHADOWING,
      7,
    );

    let streak = 0;
    for (const result of recentResults) {
      if (result.totalScore >= 70) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /**
   * Generate feedback based on scores
   */
  private generateFeedback(
    followingScore: number,
    pronunciationScore: number,
    rhythmScore: number,
  ): any {
    const feedback: any = {
      goodPoints: [],
      improvements: [],
    };

    // Following feedback
    if (followingScore >= 80) {
      feedback.goodPoints.push('Excellent timing and following!');
    } else if (followingScore < 60) {
      feedback.improvements.push('Practice following the audio more closely');
    }

    // Pronunciation feedback
    if (pronunciationScore >= 80) {
      feedback.goodPoints.push('Great pronunciation!');
    } else if (pronunciationScore < 60) {
      feedback.improvements.push('Focus on pronunciation accuracy');
    }

    // Rhythm feedback
    if (rhythmScore >= 80) {
      feedback.goodPoints.push('Natural rhythm and intonation!');
    } else if (rhythmScore < 60) {
      feedback.improvements.push('Work on matching the natural rhythm');
    }

    return feedback;
  }
}
