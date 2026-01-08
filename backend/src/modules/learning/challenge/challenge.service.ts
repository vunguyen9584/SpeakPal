import { Injectable, NotFoundException } from '@nestjs/common';
import { ChallengeRepository } from './challenge.repository';
import { ChallengeResponseDto } from './dto/challenge-response.dto';
import { PrismaService } from '../../../prisma/prisma.service';
import { ChallengeType } from '@prisma/client';

const CHALLENGE_CONFIG = {
  [ChallengeType.CONVERSATION]: { min: 2, max: 5, xp: 50 },
  [ChallengeType.VOCABULARY]: { min: 5, max: 20, xp: 30 },
  [ChallengeType.PRONUNCIATION]: { min: 70, max: 90, xp: 40 },
  [ChallengeType.STREAK]: { min: 3, max: 7, xp: 100 },
  // TIME is not in original config? Adding default
  [ChallengeType.TIME]: { min: 10, max: 30, xp: 60 },
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
      return existing.map((uc) => ChallengeResponseDto.fromEntity(uc));
    }

    // Generate daily challenges
    return this.generateDailyChallenge(userId);
  }

  async generateDailyChallenge(
    userId: string,
  ): Promise<ChallengeResponseDto[]> {
    // Analyze user's 30-day activity pattern
    const pattern = await this.analyzePattern(userId);

    const challenges: ChallengeResponseDto[] = []; // Actually returns DTOs

    // Challenge 1: Based on weakness
    const weaknessType = this.selectWeaknessChallenge(pattern);
    const challenge1 = await this.createChallenge(
      userId,
      weaknessType,
      pattern.userLevel,
    );
    challenges.push(ChallengeResponseDto.fromEntity(challenge1));

    // Challenge 2: Vocabulary (most common)
    const challenge2 = await this.createChallenge(
      userId,
      ChallengeType.VOCABULARY,
      pattern.userLevel,
    );
    challenges.push(ChallengeResponseDto.fromEntity(challenge2));

    // Challenge 3: Time-based
    const challenge3 = await this.createChallenge(
      userId,
      ChallengeType.TIME,
      pattern.userLevel,
    );
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
    const config =
      CHALLENGE_CONFIG[type] || CHALLENGE_CONFIG[ChallengeType.CONVERSATION];
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
    const uc = await this.prisma.userChallenge.findUnique({
      where: { id: challengeId },
      include: { challenge: true },
    });

    if (!uc) {
      throw new NotFoundException('Challenge not found');
    }

    if (uc.userId !== userId) {
      throw new NotFoundException('Challenge not found');
    }

    if (uc.status === 'COMPLETED') {
      return { xpEarned: 0, completed: true };
    }

    await this.repository.markCompleted(challengeId);

    return {
      xpEarned: uc.challenge.xpReward,
      completed: true,
    };
  }

  async updateProgress(
    userId: string,
    challengeId: string,
    progress: number,
  ): Promise<ChallengeResponseDto> {
    const uc = await this.prisma.userChallenge.findUnique({
      where: { id: challengeId },
    });

    if (!uc || uc.userId !== userId) {
      throw new NotFoundException('Challenge not found');
    }

    const updated = await this.repository.updateProgress(challengeId, progress);
    return ChallengeResponseDto.fromEntity(updated);
  }
}
