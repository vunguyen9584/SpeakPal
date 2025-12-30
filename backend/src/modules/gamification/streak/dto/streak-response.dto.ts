import { ApiProperty } from '@nestjs/swagger';

export class StreakResponseDto {
  @ApiProperty()
  currentStreak: number;

  @ApiProperty()
  longestStreak: number;

  @ApiProperty()
  freezeRemaining: number;

  @ApiProperty()
  lastActivityDate: Date;

  @ApiProperty()
  nextMilestone: number;

  @ApiProperty()
  daysUntilMilestone: number;
}
