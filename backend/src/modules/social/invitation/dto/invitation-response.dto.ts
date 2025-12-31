export class InvitationResponseDto {
  id: string;
  inviteCode: string;
  inviteUrl: string;
  usageCount: number;
  maxUsage: number;
  expiresAt: Date;
  createdAt: Date;
  isActive: boolean;

  constructor(partial: Partial<InvitationResponseDto>) {
    Object.assign(this, partial);
  }

  static fromEntity(entity: any, baseUrl: string): InvitationResponseDto {
    return new InvitationResponseDto({
      id: entity.id,
      inviteCode: entity.code,
      inviteUrl: `${baseUrl}/invite/${entity.code}`,
      usageCount: entity.usageCount || 0,
      maxUsage: entity.maxUsage,
      expiresAt: entity.expiresAt,
      createdAt: entity.createdAt,
      isActive: entity.usageCount < entity.maxUsage && entity.expiresAt > new Date(),
    });
  }
}
