import { ApiProperty } from '@nestjs/swagger';

export class StatsResponseDto {
  @ApiProperty()
  daily: DailyStats;

  @ApiProperty()
  weekly: WeeklyStats;

  @ApiProperty()
  monthly: MonthlyStats;

  @ApiProperty()
  allTime: AllTimeStats;

  @ApiProperty()
  averagePronunciation: number;

  @ApiProperty()
  currentStreak: number;
}

export class DailyStats {
  @ApiProperty()
  conversations: number;

  @ApiProperty()
  minutes: number;

  @ApiProperty()
  xp: number;

  @ApiProperty()
  vocabulary: number;
}

export class WeeklyStats {
  @ApiProperty()
  conversations: number;

  @ApiProperty()
  minutes: number;

  @ApiProperty()
  xp: number;

  @ApiProperty()
  vocabulary: number;
}

export class MonthlyStats {
  @ApiProperty()
  conversations: number;

  @ApiProperty()
  minutes: number;

  @ApiProperty()
  xp: number;

  @ApiProperty()
  vocabulary: number;
}

export class AllTimeStats {
  @ApiProperty()
  totalConversations: number;

  @ApiProperty()
  totalMinutes: number;

  @ApiProperty()
  totalXp: number;
}
