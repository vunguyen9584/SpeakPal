import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import {
  UserChallenge,
  Challenge,
  ChallengeType,
  ChallengeStatus,
} from '@prisma/client';

export type UserChallengeWithChallenge = UserChallenge & {
  challenge: Challenge;
};

@Injectable()
export class ChallengeRepository {
  constructor(private prisma: PrismaService) {}

  async findTodayChallenges(
    userId: string,
  ): Promise<UserChallengeWithChallenge[]> {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const userChallenges = await this.prisma.userChallenge.findMany({
      where: {
        userId,
        assignedDate: {
          gte: today,
          lt: tomorrow,
        },
      },
      include: {
        challenge: true,
      },
    });

    return userChallenges;
  }

  async createUserChallenge(
    userId: string,
    type: ChallengeType,
    targetProgress: number,
    xpReward: number,
  ): Promise<UserChallengeWithChallenge> {
    // Create a new Challenge definition (or could reuse if we implemented caching/lookup)
    // For now, creating a new one to support the dynamic nature of the code
    const challenge = await this.prisma.challenge.create({
      data: {
        type,
        title: `${type} Challenge`, // Generic title
        titleJa: `${type} Challenge`, // Placeholder
        description: `Complete ${targetProgress} ${type} tasks`,
        condition: { target: targetProgress },
        xpReward,
        isActive: true,
      },
    });

    // Assign to user
    const userChallenge = await this.prisma.userChallenge.create({
      data: {
        userId,
        challengeId: challenge.id,
        assignedDate: new Date(),
        currentProgress: 0,
        status: ChallengeStatus.ACTIVE,
      },
      include: {
        challenge: true,
      },
    });

    return userChallenge;
  }

  async updateProgress(
    id: string,
    newProgress: number,
  ): Promise<UserChallengeWithChallenge | null> {
    const uc = await this.prisma.userChallenge.findUnique({
      where: { id },
      include: { challenge: true },
    });

    if (!uc) return null;

    const targetProxy =
      ((uc.challenge.condition as Record<string, any>)?.target as number) || 1;
    const isCompleted = newProgress >= targetProxy;

    return this.prisma.userChallenge.update({
      where: { id },
      data: {
        currentProgress: newProgress,
        status: isCompleted
          ? ChallengeStatus.COMPLETED
          : ChallengeStatus.ACTIVE,
        completedAt: isCompleted ? new Date() : null,
      },
      include: {
        challenge: true,
      },
    });
  }

  async markCompleted(id: string): Promise<UserChallengeWithChallenge> {
    return this.prisma.userChallenge.update({
      where: { id },
      data: {
        status: ChallengeStatus.COMPLETED,
        completedAt: new Date(),
      },
      include: {
        challenge: true,
      },
    });
  }
}
