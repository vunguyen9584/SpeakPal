import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InvitationRepository } from './invitation.repository';
import { CreateInvitationDto } from './dto/create-invitation.dto';
import { InvitationResponseDto } from './dto/invitation-response.dto';
import { randomBytes } from 'crypto';
import { InvitationStatus, Invitation } from '@prisma/client';

@Injectable()
export class InvitationService {
  constructor(private readonly invitationRepo: InvitationRepository) {}

  /**
   * Generate a unique invite code for a user
   */
  async generateInviteCode(
    userId: string,
    dto: CreateInvitationDto = {},
  ): Promise<InvitationResponseDto> {
    const code = this.generateUniqueCode(8);
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + (dto.expiryDays || 30));

    const invitation = await this.invitationRepo.create({
      userId,
      code,
      expiresAt,
      maxUsage: dto.maxUsage,
    });

    const baseUrl = process.env.APP_URL || 'https://speakpal.app';
    return InvitationResponseDto.fromEntity(invitation, baseUrl);
  }

  /**
   * Accept an invitation and record referral
   */
  async acceptInvitation(code: string, newUserId: string): Promise<void> {
    const invitation = await this.invitationRepo.findByCode(code);

    if (!invitation) {
      throw new NotFoundException('Invitation not found');
    }

    // Validate invitation
    if (invitation.status !== InvitationStatus.PENDING) {
      throw new BadRequestException(
        'Invitation has already been used or is not pending',
      );
    }

    if (invitation.expiresAt < new Date()) {
      throw new BadRequestException('Invitation has expired');
    }

    if (invitation.senderId === newUserId) {
      throw new BadRequestException('You cannot accept your own invitation');
    }

    const inv = invitation as unknown as Invitation & {
      maxUsage?: number;
      usageCount: number;
    };
    if (inv.maxUsage && inv.usageCount >= inv.maxUsage) {
      throw new BadRequestException('Invitation limit has been reached');
    }

    // Accept invitation
    await this.invitationRepo.acceptInvitation(invitation.id, newUserId);

    // Award referral bonus
    await this.awardReferralBonus(invitation.senderId);
  }

  /**
   * Get all invitations created by a user
   */
  async getUserInvitations(userId: string): Promise<InvitationResponseDto[]> {
    const invitations = await this.invitationRepo.findByUserId(userId);
    const baseUrl = process.env.APP_URL || 'https://speakpal.app';

    return invitations.map((inv) =>
      InvitationResponseDto.fromEntity(inv, baseUrl),
    );
  }

  /**
   * Get referral statistics for a user
   */
  async getReferralStats(userId: string) {
    const referralCount = await this.invitationRepo.getReferralCount(userId);
    const referrals = await this.invitationRepo.getReferrals(userId);

    return {
      totalReferrals: referralCount,
      referrals: referrals.map((inv) => ({
        userId: inv.receiver?.id,
        userName: inv.receiver?.username || inv.receiver?.email,
        userAvatar: null, // Avatar not in schema
        referredAt: inv.usedAt,
      })),
      rewards: this.calculateRewards(referralCount),
    };
  }

  /**
   * Generate unique alphanumeric code
   */
  private generateUniqueCode(length: number): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const bytes = randomBytes(length);
    let code = '';

    for (let i = 0; i < length; i++) {
      code += chars[bytes[i] % chars.length];
    }

    return code;
  }

  /**
   * Award referral bonus based on referral count
   * Referral Rewards:
   * - 1 referral: 1 streak freeze
   * - 5 referrals: 100 bonus XP
   * - 10 referrals: 1 week premium trial
   */
  private async awardReferralBonus(userId: string): Promise<void> {
    const referralCount = await this.invitationRepo.getReferralCount(userId);

    // Award streak freeze at 1, 5, 10 referrals
    if (referralCount === 1 || referralCount === 5 || referralCount === 10) {
      // TODO: Integrate with Gamification module to award streak freeze
      // await this.gamificationService.addStreakFreeze(userId, 1);
    }

    // Award 100 XP at 5 referrals
    if (referralCount === 5) {
      // TODO: Integrate with Gamification module to award XP
      // await this.gamificationService.addXP(userId, 100, 'referral_bonus');
    }

    // Award premium trial at 10 referrals
    if (referralCount === 10) {
      // TODO: Integrate with Subscription module to grant premium trial
      // await this.subscriptionService.grantPremiumTrial(userId, 7);
    }
  }

  /**
   * Calculate rewards earned based on referral count
   */
  private calculateRewards(referralCount: number) {
    const rewards: {
      type: string;
      amount?: number;
      days?: number;
      unlocked: boolean;
      required?: number;
    }[] = [];

    if (referralCount >= 1) {
      rewards.push({ type: 'streak_freeze', amount: 1, unlocked: true });
    }

    if (referralCount >= 5) {
      rewards.push({ type: 'bonus_xp', amount: 100, unlocked: true });
      rewards.push({ type: 'streak_freeze', amount: 1, unlocked: true });
    } else {
      rewards.push({
        type: 'bonus_xp',
        amount: 100,
        unlocked: false,
        required: 5,
      });
    }

    if (referralCount >= 10) {
      rewards.push({ type: 'premium_trial', days: 7, unlocked: true });
      rewards.push({ type: 'streak_freeze', amount: 1, unlocked: true });
    } else {
      rewards.push({
        type: 'premium_trial',
        days: 7,
        unlocked: false,
        required: 10,
      });
    }

    return rewards;
  }
}
