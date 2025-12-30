import { Injectable, NotFoundException } from '@nestjs/common';
import { ChallengeRepository } from './challenge.repository';
import { ChallengeResponseDto, ChallengeType } from './dto/challenge-response.dto';
import { PrismaService } from '../../../common/prisma/prisma.service';

const CHALLENGE_CONFIG = {
  conversation: { min: 2, max: 5, xp: 50 },
  vocabulary: { min: 5, max: 20, xp: 30 },
  pronunciation: { min: 70, max: 90, xp: 40 },
  streak: { min: 3, max: 7, xp: 100 },
  time: { min: 10, max: 30, xp: 60 },
};

@Injectable()
export class ChallengeService {
  constructor(
    private readonly repository: ChallengeRepository,
    private readonly prisma: PrismaService,
  ) {}

  async getTodayChallenge(userId: string): Promise<ChallengeResponseDto[]> {
    const existing = await this.repository.findTodayChallenges(userId);
    if (existing.length > 0) {
      return existing.map(ChallengeResponseDto.fromEntity);
    }

    // Generate daily challenges
    return this.generateDailyChallenge(userId);
  }

  async generateDailyChallenge(userId: string): Promise<ChallengeResponseDto[]> {
    // Analyze user's 30-day activity pattern
    const pattern = await this.analyzePattern(userId);

    // Generate 3 challenges: 1 weakness-focused, 1 balanced, 1 variety
    const challenges: ChallengeResponseDto[] = [];

    // Challenge 1: Based on weakness
    const weaknessType = this.selectWeaknessChallenge(pattern);
    const challenge1 = await this.createChallenge(userId, weaknessType, pattern.userLevel);
    challenges.push(ChallengeResponseDto.fromEntity(challenge1));

    // Challenge 2: Vocabulary (most common)
    const challenge2 = await this.createChallenge(userId, ChallengeType.VOCABULARY, pattern.userLevel);
    challenges.push(ChallengeResponseDto.fromEntity(challenge2));

    // Challenge 3: Time-based
    const challenge3 = await this.createChallenge(userId, ChallengeType.TIME, pattern.userLevel);
    challenges.push(ChallengeResponseDto.fromEntity(challenge3));

    return challenges;
  }

  private async analyzePattern(userId: string): Promise<any> {
    // TODO: Implement 30-day pattern analysis
    // For now, return default pattern
    return {
      userLevel: 'beginner',
      conversationCount: 5,
      vocabularyCount: 10,
      avgPronunciation: 75,
      currentStreak: 2,
    };
  }

  private selectWeaknessChallenge(pattern: any): ChallengeType {
    // Select based on what user does least
    if (pattern.conversationCount < 10) {
      return ChallengeType.CONVERSATION;
    }
    if (pattern.avgPronunciation < 70) {
      return ChallengeType.PRONUNCIATION;
    }
    return ChallengeType.CONVERSATION;
  }

  private async createChallenge(
    userId: string,
    type: ChallengeType,
    userLevel: string,
  ) {
    const config = CHALLENGE_CONFIG[type];
    const difficulty = this.adjustDifficulty(userLevel);

    const targetProgress = Math.floor(
      config.min + (config.max - config.min) * difficulty,
    );

    return this.repository.createUserChallenge(
      userId,
      type,
      targetProgress,
      config.xp,
    );
  }

  private adjustDifficulty(userLevel: string): number {
    switch (userLevel) {
      case 'beginner':
        return 0.3;
      case 'intermediate':
        return 0.6;
      case 'advanced':
        return 1.0;
      default:
        return 0.5;
    }
  }

  async completeChallenge(
    userId: string,
    challengeId: string,
  ): Promise<{ xpEarned: number; completed: boolean }> {
    const challenge = await this.prisma.userChallenge.findUnique({
      where: { id: challengeId },
    });

    if (!challenge) {
      throw new NotFoundException('Challenge not found');
    }

    if (challenge.userId !== userId) {
      throw new NotFoundException('Challenge not found');
    }

    if (challenge.completed) {
      return { xpEarned: 0, completed: true };
    }

    await this.repository.markCompleted(challengeId);

    return {
      xpEarned: challenge.xpReward,
      completed: true,
    };
  }

  async updateProgress(
    userId: string,
    challengeId: string,
    progress: number,
  ): Promise<ChallengeResponseDto> {
    const challenge = await this.prisma.userChallenge.findUnique({
      where: { id: challengeId },
    });

    if (!challenge || challenge.userId !== userId) {
      throw new NotFoundException('Challenge not found');
    }

    const updated = await this.repository.updateProgress(challengeId, progress);
    return ChallengeResponseDto.fromEntity(updated);
  }
}

