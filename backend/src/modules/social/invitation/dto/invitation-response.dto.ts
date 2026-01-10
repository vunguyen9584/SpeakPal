import { InvitationStatus, Invitation } from '@prisma/client';

export class InvitationResponseDto {
  id: string;
  inviteCode: string;
  inviteUrl: string;
  expiresAt: Date;
  createdAt: Date;
  isActive: boolean;

  status: InvitationStatus;
  maxUsage?: number;
  usageCount: number;

  constructor(partial: Partial<InvitationResponseDto>) {
    Object.assign(this, partial);
  }

  static fromEntity(
    entity: Invitation,
    baseUrl: string,
  ): InvitationResponseDto {
    const inv = entity as Invitation & { maxUsage?: number };
    const isActive =
      inv.status === InvitationStatus.PENDING && inv.expiresAt > new Date();

    return new InvitationResponseDto({
      id: entity.id,
      inviteCode: entity.code,
      inviteUrl: `${baseUrl}/invite/${entity.code}`,
      expiresAt: entity.expiresAt,
      createdAt: entity.createdAt,
      status: entity.status,
      maxUsage: inv.maxUsage,
      isActive,
      usageCount: entity.usageCount,
    });
  }
}
