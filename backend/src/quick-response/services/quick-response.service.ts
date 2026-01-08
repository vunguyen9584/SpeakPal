import { Injectable, Logger } from '@nestjs/common';
import { PracticeType } from '@prisma/client';
import { QuickResponseRepository } from '../repositories';
import { v4 as uuidv4 } from 'uuid';

// Daily limits by subscription plan
const DAILY_LIMITS: Record<
  string,
  { wordAssociation: number; instantDrill: number }
> = {
  FREE: { wordAssociation: 10, instantDrill: 10 },
  PREMIUM: { wordAssociation: 50, instantDrill: 50 },
  PREMIUM_PLUS: { wordAssociation: 999999, instantDrill: 999999 },
};

@Injectable()
export class QuickResponseService {
  private readonly _logger = new Logger(QuickResponseService.name);

  constructor(private readonly repository: QuickResponseRepository) {}

  /**
   * Start a new quick response session
   * Returns session configuration and word list
   */
  async startSession(
    userId: string,
    practiceType: PracticeType,
    difficulty: number = 3,
    userPlan: string = 'FREE',
  ): Promise<Record<string, any>> {
    // 1. Check daily limit
    const dailyCount = await this.repository.getDailyCount(
      userId,
      practiceType,
    );
    const limitKey =
      practiceType === PracticeType.WORD_ASSOCIATION
        ? 'wordAssociation'
        : 'instantDrill';
    const limit =
      DAILY_LIMITS[userPlan]?.[limitKey] || DAILY_LIMITS.FREE[limitKey];

    if (dailyCount >= limit) {
      throw new Error('本日の練習回数上限に達しました (Daily limit reached)');
    }

    // 2. Generate session ID
    const sessionId = uuidv4();

    // 3. Generate word list based on practice type and difficulty
    const wordList = this.generateWordList(practiceType, difficulty);

    // 4. Return session configuration
    return {
      sessionId,
      practiceType,
      difficulty,
      wordList,
      timeLimit: practiceType === PracticeType.WORD_ASSOCIATION ? 60 : 120, // seconds
      dailyProgress: { completed: dailyCount, limit },
    };
  }

  /**
   * Submit quick response session results
   * Calculate XP and save results
   */
  async submitResult(
    userId: string,
    sessionId: string,
    practiceType: PracticeType,
    totalScore: number,
    correctCount: number,
    maxChain: number,
    durationSec: number,
    details?: Record<string, any>,
  ): Promise<Record<string, any>> {
    // 1. Calculate XP based on performance
    let xpEarned = 15; // Base XP

    // Bonus for high score
    if (totalScore >= 80) xpEarned += 10;
    if (totalScore >= 90) xpEarned += 5;

    // Bonus for chain
    if (maxChain >= 5) xpEarned += 10;
    if (maxChain >= 10) xpEarned += 15;

    // 2. Check streak
    const streak = await this.getQuickResponseStreak(userId, practiceType);
    const streakBonus = totalScore >= 70 && streak >= 3;
    if (streakBonus) xpEarned += 20;

    // 3. Save result
    const result = await this.repository.create({
      userId,
      practiceType,
      sessionId,
      totalScore,
      correctCount,
      maxChain,
      durationSec,
      details,
      xpEarned,
    });

    // 4. Return response
    return {
      id: result.id,
      practiceType: result.practiceType,
      totalScore: result.totalScore,
      correctCount: result.correctCount,
      maxChain: result.maxChain,
      xpEarned: result.xpEarned,
      streakBonus,
      feedback: this.generateFeedback(totalScore, maxChain, correctCount),
    };
  }

  /**
   * Get user's quick response history
   */
  async getHistory(
    userId: string,
    practiceType?: PracticeType,
    limit: number = 20,
  ): Promise<Record<string, any>[]> {
    const results = await this.repository.getUserHistory(
      userId,
      practiceType,
      limit,
    );

    return results.map((result) => ({
      id: result.id,
      practiceType: result.practiceType,
      totalScore: result.totalScore,
      correctCount: result.correctCount,
      maxChain: result.maxChain,
      xpEarned: result.xpEarned,
      createdAt: result.createdAt,
    }));
  }

  /**
   * Generate word list for practice session
   */
  private generateWordList(
    practiceType: PracticeType,
    difficulty: number,
  ): Record<string, any>[] {
    // Mock word list generation
    // In production, this would fetch from database based on difficulty
    const wordLists: Partial<Record<PracticeType, Record<string, any>[]>> = {
      [PracticeType.WORD_ASSOCIATION]: [
        { word: 'happy', category: 'emotion', difficulty: 1 },
        { word: 'computer', category: 'technology', difficulty: 2 },
        { word: 'beautiful', category: 'description', difficulty: 2 },
        { word: 'achievement', category: 'abstract', difficulty: 3 },
        { word: 'entrepreneur', category: 'business', difficulty: 4 },
        { word: 'sophisticated', category: 'description', difficulty: 4 },
        { word: 'philosophical', category: 'abstract', difficulty: 5 },
      ],
      [PracticeType.INSTANT_DRILL]: [
        {
          prompt: 'How are you?',
          expectedResponse: "I'm fine, thank you",
          difficulty: 1,
        },
        {
          prompt: 'What time is it?',
          expectedResponse: "It's 3 o'clock",
          difficulty: 1,
        },
        {
          prompt: 'Can you help me?',
          expectedResponse: 'Of course, what do you need?',
          difficulty: 2,
        },
        {
          prompt: 'Where is the station?',
          expectedResponse: 'Go straight and turn left',
          difficulty: 2,
        },
        {
          prompt: 'Could you explain that again?',
          expectedResponse: 'Sure, let me clarify',
          difficulty: 3,
        },
      ],
    };

    const list = wordLists[practiceType] || [];
    return list.filter((item) => item.difficulty <= difficulty).slice(0, 10);
  }

  /**
   * Get quick response practice streak
   */
  private async getQuickResponseStreak(
    userId: string,
    practiceType: PracticeType,
  ): Promise<number> {
    const recentResults = await this.repository.getRecentResults(
      userId,
      practiceType,
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
   * Generate feedback based on performance
   */
  private generateFeedback(
    totalScore: number,
    maxChain: number,
    correctCount: number,
  ): { goodPoints: string[]; improvements: string[] } {
    const feedback: { goodPoints: string[]; improvements: string[] } = {
      goodPoints: [],
      improvements: [],
    };

    if (totalScore >= 80) {
      feedback.goodPoints.push('Excellent performance!');
    }
    if (maxChain >= 5) {
      feedback.goodPoints.push('Great chain combo!');
    }
    if (correctCount >= 8) {
      feedback.goodPoints.push('High accuracy!');
    }

    if (totalScore < 70) {
      feedback.improvements.push('Practice more to improve speed');
    }
    if (maxChain < 3) {
      feedback.improvements.push('Try to maintain longer chains');
    }

    return feedback;
  }
}
