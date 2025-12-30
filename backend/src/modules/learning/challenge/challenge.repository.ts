import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { UserChallenge, ChallengeType } from '@prisma/client';

@Injectable()
export class ChallengeRepository {
  constructor(private prisma: PrismaService) {}

  async findTodayChallenges(userId: string): Promise<UserChallenge[]> {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    return this.prisma.userChallenge.findMany({
      where: {
        userId,
        date: {
          gte: today,
          lt: tomorrow,
        },
      },
    });
  }

  async createUserChallenge(
    userId: string,
    type: ChallengeType,
    targetProgress: number,
    xpReward: number,
  ): Promise<UserChallenge> {
    return this.prisma.userChallenge.create({
      data: {
        userId,
        type,
        targetProgress,
        currentProgress: 0,
        xpReward,
        completed: false,
        date: new Date(),
      },
    });
  }

  async updateProgress(
    id: string,
    newProgress: number,
  ): Promise<UserChallenge> {
    return this.prisma.userChallenge.update({
      where: { id },
      data: {
        currentProgress: newProgress,
        completed: newProgress >= (await this.prisma.userChallenge.findUnique({ where: { id } })).targetProgress,
      },
    });
  }

  async markCompleted(id: string): Promise<UserChallenge> {
    return this.prisma.userChallenge.update({
      where: { id },
      data: { completed: true },
    });
  }
}
