import { ApiProperty } from '@nestjs/swagger';

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

  static fromEntity(challenge: any): ChallengeResponseDto {
    const dto = new ChallengeResponseDto();
    dto.id = challenge.id;
    dto.type = challenge.type;
    dto.title = challenge.title;
    dto.description = challenge.description;
    dto.targetProgress = challenge.targetProgress;
    dto.currentProgress = challenge.currentProgress;
    dto.xpReward = challenge.xpReward;
    dto.completed = challenge.completed;
    dto.date = challenge.date;
    return dto;
  }
}
