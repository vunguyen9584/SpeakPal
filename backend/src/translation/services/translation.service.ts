import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { Level, PracticeType } from '@prisma/client';
import {
  TranslationQuestionRepository,
  TranslationResultRepository,
  IntentQuestionRepository,
} from '../repositories';
import {
  TranslationQuestionResponseDto,
  TranslationResultResponseDto,
} from '../dto';

// Daily limits by subscription plan
const DAILY_LIMITS: Record<
  string,
  { directTranslation: number; intentTranslation: number }
> = {
  FREE: { directTranslation: 10, intentTranslation: 5 },
  PREMIUM: { directTranslation: 50, intentTranslation: 30 },
  PREMIUM_PLUS: { directTranslation: 999999, intentTranslation: 999999 },
};

@Injectable()
export class TranslationService {
  private readonly _logger = new Logger(TranslationService.name);

  constructor(
    private readonly questionRepo: TranslationQuestionRepository,
    private readonly resultRepo: TranslationResultRepository,
    private readonly intentRepo: IntentQuestionRepository,
  ) {}

  /**
   * Get a translation question for the user
   * Implements BR-095: Avoid recently shown questions (7-day cache)
   * Implements BR-099: Daily limits based on subscription
   */
  async getTranslationQuestion(
    userId: string,
    topic: string,
    level?: Level,
    userPlan: string = 'FREE',
  ): Promise<TranslationQuestionResponseDto> {
    // 1. Check daily limit (BR-099)
    const dailyCount = await this.resultRepo.getDailyCount(
      userId,
      PracticeType.DIRECT,
    );
    const limit =
      DAILY_LIMITS[userPlan]?.directTranslation ||
      DAILY_LIMITS.FREE.directTranslation;

    if (dailyCount >= limit) {
      throw new Error('本日の練習回数上限に達しました (Daily limit reached)');
    }

    // 2. Get recently shown question IDs (would use Redis in production)
    // For now, we'll use empty array - Redis integration can be added later
    const recentIds: string[] = [];

    // 3. Fetch random question excluding recent
    const userLevel = level || Level.BEGINNER;
    let question = await this.questionRepo.findRandomQuestion(
      topic,
      userLevel,
      recentIds,
    );

    // 4. If all exhausted, get any question
    if (!question) {
      question = await this.questionRepo.findRandomQuestion(
        topic,
        userLevel,
        [],
      );
    }

    if (!question) {
      throw new NotFoundException(
        '利用可能な問題がありません (No questions available)',
      );
    }

    // 5. Return response with daily progress
    return TranslationQuestionResponseDto.fromEntity(question, {
      dailyProgress: { completed: dailyCount, limit },
    });
  }

  /**
   * Evaluate user's translation answer
   * Implements BR-097: Speed scoring
   * Implements BR-098: XP calculation with streak bonus
   */
  async evaluateTranslation(
    userId: string,
    questionId: string,
    userAnswer: string,
    responseTimeSec: number,
    userPlan: string = 'FREE',
  ): Promise<TranslationResultResponseDto> {
    // 1. Check daily limit
    const dailyCount = await this.resultRepo.getDailyCount(
      userId,
      PracticeType.DIRECT,
    );
    const limit =
      DAILY_LIMITS[userPlan]?.directTranslation ||
      DAILY_LIMITS.FREE.directTranslation;

    if (dailyCount >= limit) {
      throw new Error('本日の練習回数上限に達しました');
    }

    // 2. Get question
    const question = await this.questionRepo.findById(questionId);
    if (!question) {
      throw new NotFoundException('問題が見つかりません (Question not found)');
    }

    // 3. AI evaluation (mock for now - would integrate with LLM service)
    const aiEval = this.mockAIEvaluation(userAnswer, question.targetText);

    // 4. Calculate speed score (BR-097)
    const speedScore = this.calculateSpeedScore(responseTimeSec);

    // 5. Calculate total score (40% grammar, 30% vocab, 30% speed)
    const totalScore = Math.round(
      aiEval.grammarScore * 0.4 + aiEval.vocabScore * 0.3 + speedScore * 0.3,
    );

    // 6. Calculate XP (BR-098)
    let xpEarned = 20; // Base XP
    if (totalScore >= 80) xpEarned += 10; // High score bonus

    // Check streak (simplified - would check actual consecutive days)
    const streak = await this.getTranslationStreak(userId);
    const streakBonus = totalScore >= 70 && streak >= 4;
    if (streakBonus) xpEarned += 30; // Streak bonus

    // 7. Save result
    const result = await this.resultRepo.create({
      userId,
      practiceType: PracticeType.DIRECT,
      questionId,
      userAnswer,
      totalScore,
      grammarScore: aiEval.grammarScore,
      vocabScore: aiEval.vocabScore,
      speedScore,
      responseTimeSec,
      feedback: aiEval.feedback,
      xpEarned,
    });

    // 8. Return response
    return TranslationResultResponseDto.fromEntity(
      result,
      question.targetText,
      streakBonus,
    );
  }

  /**
   * Get intent translation question
   * Implements UC-035: Intent-based translation
   * Implements BR-101: Intermediate+ level only
   */
  async getIntentQuestion(
    userId: string,
    category: string,
    level?: Level,
    userPlan: string = 'FREE',
  ): Promise<Record<string, any>> {
    // 1. Check level restriction (BR-101)
    const userLevel = level || Level.BEGINNER;
    if (userLevel === Level.BEGINNER || userLevel === Level.ELEMENTARY) {
      throw new Error(
        'Intent translation requires Intermediate level or higher',
      );
    }

    // 2. Check daily limit (BR-106)
    const dailyCount = await this.resultRepo.getDailyCount(
      userId,
      PracticeType.INTENT,
    );
    const limit =
      DAILY_LIMITS[userPlan]?.intentTranslation ||
      DAILY_LIMITS.FREE.intentTranslation;

    if (dailyCount >= limit) {
      throw new Error('本日の練習回数上限に達しました');
    }

    // 3. Get random intent question
    const question = await this.intentRepo.findRandomQuestion(
      category,
      userLevel,
    );

    if (!question) {
      throw new NotFoundException('利用可能な問題がありません');
    }

    // 4. Return response
    return {
      id: question.id,
      category: question.category,
      level: question.level,
      intentDescription: question.intentDescription,
      difficulty: question.difficulty,
      dailyProgress: { completed: dailyCount, limit },
    };
  }

  /**
   * Evaluate intent expression
   * Implements BR-102: Multiple correct expressions
   * Implements BR-104: XP calculation for intent
   */
  async evaluateIntentExpression(
    userId: string,
    questionId: string,
    userExpression: string,
  ): Promise<Record<string, any>> {
    // 1. Get question
    const question = await this.intentRepo.findById(questionId);
    if (!question) {
      throw new NotFoundException('問題が見つかりません');
    }

    // 2. AI evaluation (mock)
    const aiEval = this.mockIntentEvaluation(
      userExpression,
      question.expectedExpressions as string[],
    );

    // 3. Calculate total score (40% intent match, 30% naturalness, 30% vocab)
    const totalScore = Math.round(
      aiEval.intentScore * 0.4 +
        aiEval.naturalnessScore * 0.3 +
        aiEval.vocabScore * 0.3,
    );

    // 4. Calculate XP (BR-104)
    let xpEarned = 30; // Base XP
    if (totalScore >= 85) xpEarned += 20; // High score bonus

    // 5. Save result
    const result = await this.resultRepo.create({
      userId,
      practiceType: PracticeType.INTENT,
      questionId,
      userAnswer: userExpression,
      totalScore,
      intentScore: aiEval.intentScore,
      vocabScore: aiEval.vocabScore,
      feedback: aiEval.feedback,
      xpEarned,
    });

    // 6. Return response
    return {
      id: result.id,
      userExpression,
      totalScore,
      intentScore: aiEval.intentScore,
      naturalnessScore: aiEval.naturalnessScore,
      vocabScore: aiEval.vocabScore,
      expectedExpressions: question.expectedExpressions,
      alternativePhrases: question.alternativePhrases,
      feedback: aiEval.feedback,
      xpEarned,
    };
  }

  /**
   * Calculate speed score based on response time
   * Implements BR-097
   */
  private calculateSpeedScore(responseTimeSec: number): number {
    if (responseTimeSec <= 5) return 100;
    if (responseTimeSec <= 10) return 80;
    if (responseTimeSec <= 15) return 60;
    if (responseTimeSec <= 20) return 40;
    return 20;
  }

  /**
   * Get translation practice streak
   * Returns number of consecutive days with successful practice
   */
  private async getTranslationStreak(userId: string): Promise<number> {
    const recentResults = await this.resultRepo.getRecentResults(
      userId,
      PracticeType.DIRECT,
      7,
    );

    // Simplified streak calculation
    // In production, would check consecutive days with score >= 70
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
   * Mock AI evaluation for translation
   * In production, this would call LLM service
   */
  private mockAIEvaluation(
    userAnswer: string,
    targetText: string,
  ): {
    grammarScore: number;
    vocabScore: number;
    feedback: {
      goodPoints: string[];
      improvements: string[];
      grammarNotes: string;
    };
  } {
    // Simple similarity check for demo
    const similarity = this.calculateSimilarity(
      userAnswer.toLowerCase(),
      targetText.toLowerCase(),
    );

    const grammarScore = Math.min(100, Math.round(similarity * 100 + 20));
    const vocabScore = Math.min(100, Math.round(similarity * 100 + 15));

    return {
      grammarScore,
      vocabScore,
      feedback: {
        goodPoints: ['Good attempt at translation'],
        improvements: ['Consider using more natural expressions'],
        grammarNotes: 'Grammar structure is acceptable',
      },
    };
  }

  /**
   * Mock AI evaluation for intent expression
   */
  private mockIntentEvaluation(
    userExpression: string,
    expectedExpressions: string[],
  ): {
    intentScore: number;
    naturalnessScore: number;
    vocabScore: number;
    feedback: { goodPoints: string[]; improvements: string[] };
  } {
    // Check if user expression matches any expected expression
    const maxSimilarity = Math.max(
      ...expectedExpressions.map((exp) =>
        this.calculateSimilarity(
          userExpression.toLowerCase(),
          exp.toLowerCase(),
        ),
      ),
    );

    const intentScore = Math.min(100, Math.round(maxSimilarity * 100 + 10));
    const naturalnessScore = Math.min(100, Math.round(maxSimilarity * 90 + 20));
    const vocabScore = Math.min(100, Math.round(maxSimilarity * 95 + 15));

    return {
      intentScore,
      naturalnessScore,
      vocabScore,
      feedback: {
        goodPoints: ['Intent is clear'],
        improvements: ['Try using more polite expressions'],
      },
    };
  }

  /**
   * Simple string similarity calculation
   */
  private calculateSimilarity(str1: string, str2: string): number {
    const longer = str1.length > str2.length ? str1 : str2;
    const shorter = str1.length > str2.length ? str2 : str1;

    if (longer.length === 0) return 1.0;

    const editDistance = this.levenshteinDistance(longer, shorter);
    return (longer.length - editDistance) / longer.length;
  }

  /**
   * Levenshtein distance for string similarity
   */
  private levenshteinDistance(str1: string, str2: string): number {
    const matrix: number[][] = [];

    for (let i = 0; i <= str2.length; i++) {
      matrix[i] = [i];
    }

    for (let j = 0; j <= str1.length; j++) {
      matrix[0][j] = j;
    }

    for (let i = 1; i <= str2.length; i++) {
      for (let j = 1; j <= str1.length; j++) {
        if (str2.charAt(i - 1) === str1.charAt(j - 1)) {
          matrix[i][j] = matrix[i - 1][j - 1];
        } else {
          matrix[i][j] = Math.min(
            matrix[i - 1][j - 1] + 1,
            matrix[i][j - 1] + 1,
            matrix[i - 1][j] + 1,
          );
        }
      }
    }

    return matrix[str2.length][str1.length];
  }
}
