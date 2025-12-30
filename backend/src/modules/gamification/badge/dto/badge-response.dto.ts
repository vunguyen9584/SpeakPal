import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum BadgeCategory {
  STREAK = 'streak',
  LEVEL = 'level',
  CONVERSATION = 'conversation',
  VOCABULARY = 'vocabulary',
  OTHER = 'other',
}

export class BadgeDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  code: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  nameJa: string;

  @ApiProperty()
  description: string;

  @ApiProperty({ enum: BadgeCategory })
  category: BadgeCategory;

  @ApiProperty()
  xpBonus: number;

  @ApiProperty()
  iconUrl: string;

  @ApiProperty()
  condition: string;
}

export class UserBadgeDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  badge: BadgeDto;

  @ApiProperty()
  earnedAt: Date;

  @ApiProperty()
  progress?: number;

  @ApiProperty()
  progressTarget?: number;
}
