import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';

@Injectable()
export class InvitationRepository {
  constructor(private prisma: PrismaService) {}

  async create(data: {
    userId: string;
    code: string;
    maxUsage: number;
    expiresAt: Date;
  }) {
    return this.prisma.invitation.create({
      data: {
        ...data,
        usageCount: 0,
      },
    });
  }

  async findByCode(code: string) {
    return this.prisma.invitation.findUnique({
      where: { code },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            displayName: true,
          },
        },
      },
    });
  }

  async findByUserId(userId: string) {
    return this.prisma.invitation.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async incrementUsageCount(invitationId: string) {
    return this.prisma.invitation.update({
      where: { id: invitationId },
      data: {
        usageCount: {
          increment: 1,
        },
      },
    });
  }

  async recordReferral(invitationId: string, newUserId: string) {
    // Increment usage count and create referral record
    await this.incrementUsageCount(invitationId);

    return this.prisma.referral.create({
      data: {
        invitationId,
        referredUserId: newUserId,
      },
    });
  }

  async getReferralCount(userId: string): Promise<number> {
    return this.prisma.referral.count({
      where: {
        invitation: {
          userId,
        },
      },
    });
  }

  async getReferrals(userId: string) {
    return this.prisma.referral.findMany({
      where: {
        invitation: {
          userId,
        },
      },
      include: {
        referredUser: {
          select: {
            id: true,
            email: true,
            displayName: true,
            avatar: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
