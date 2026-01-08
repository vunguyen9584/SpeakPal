import { InvitationStatus } from '@prisma/client';

export class InvitationResponseDto {
  id: string;
  inviteCode: string;
  inviteUrl: string;
  expiresAt: Date;
  createdAt: Date;
  isActive: boolean;
  isActive: boolean;
  status: InvitationStatus;
  maxUsage?: number;

  constructor(partial: Partial<InvitationResponseDto>) {
    Object.assign(this, partial);
  }

  static fromEntity(entity: any, baseUrl: string): InvitationResponseDto {
    const isActive =
      entity.status === InvitationStatus.PENDING &&
      entity.expiresAt > new Date();

    return new InvitationResponseDto({
      id: entity.id,
      inviteCode: entity.code,
      inviteUrl: `${baseUrl}/invite/${entity.code}`,
      expiresAt: entity.expiresAt,
      createdAt: entity.createdAt,
      status: entity.status,
      maxUsage: entity.maxUsage,
      isActive,
    });
  }
}
