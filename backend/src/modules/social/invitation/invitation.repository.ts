import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { InvitationStatus } from '@prisma/client';

@Injectable()
export class InvitationRepository {
  constructor(private prisma: PrismaService) { }

  async create(data: {
    userId: string;
    code: string;
    expiresAt: Date;
  }) {
    return this.prisma.invitation.create({
      data: {
        senderId: data.userId,
        code: data.code,
        expiresAt: data.expiresAt,
        status: InvitationStatus.PENDING,
      },
    });
  }

  async findByCode(code: string) {
    return this.prisma.invitation.findUnique({
      where: { code },
      include: {
        sender: {
          select: {
            id: true,
            email: true,
            username: true,
          },
        },
      },
    });
  }

  async findByUserId(userId: string) {
    return this.prisma.invitation.findMany({
      where: { senderId: userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async acceptInvitation(invitationId: string, receiverId: string) {
    return this.prisma.invitation.update({
      where: { id: invitationId },
      data: {
        status: InvitationStatus.ACCEPTED,
        receiverId,
        usedAt: new Date(),
      },
    });
  }

  async getReferralCount(userId: string): Promise<number> {
    return this.prisma.invitation.count({
      where: {
        senderId: userId,
        status: InvitationStatus.ACCEPTED,
      },
    });
  }

  async getReferrals(userId: string) {
    return this.prisma.invitation.findMany({
      where: {
        senderId: userId,
        status: InvitationStatus.ACCEPTED,
      },
      include: {
        receiver: {
          select: {
            id: true,
            email: true,
            username: true,
            // User model doesn't have avatar or displayName in the provided schema
            // but let's check schema again.
          },
        },
      },
      orderBy: { usedAt: 'desc' },
    });
  }
}
