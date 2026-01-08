import { ApiProperty } from '@nestjs/swagger';
import { ChallengeType as PrismaChallengeType, ChallengeStatus } from '@prisma/client';

export enum ChallengeType {
  CONVERSATION = 'conversation',
  VOCABULARY = 'vocabulary',
  PRONUNCIATION = 'pronunciation',
  STREAK = 'streak',
  TIME = 'time',
}

export class ChallengeResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: ChallengeType })
  type: ChallengeType;

  @ApiProperty()
  title: string;

  @ApiProperty()
  description: string;

  @ApiProperty()
  targetProgress: number;

  @ApiProperty()
  currentProgress: number;

  @ApiProperty()
  xpReward: number;

  @ApiProperty()
  completed: boolean;

  @ApiProperty()
  date: Date;

  static fromEntity(uc: any): ChallengeResponseDto {
    const dto = new ChallengeResponseDto();
    dto.id = uc.id;
    // Map Prisma Enum to DTO Enum (lowercase)
    dto.type = uc.challenge.type.toLowerCase() as ChallengeType;
    dto.title = uc.challenge.title;
    dto.description = uc.challenge.description;

    // Parse condition for target
    const condition = uc.challenge.condition as any;
    dto.targetProgress = condition?.target || 0;

    dto.currentProgress = uc.currentProgress;
    dto.xpReward = uc.challenge.xpReward;
    dto.completed = uc.status === ChallengeStatus.COMPLETED;
    dto.date = uc.assignedDate;
    return dto;
  }
}
