import { ApiProperty } from '@nestjs/swagger';

export enum League {
  BRONZE = 'bronze',
  SILVER = 'silver',
  GOLD = 'gold',
  PLATINUM = 'platinum',
  DIAMOND = 'diamond',
}

export class RankingEntryDto {
  @ApiProperty()
  rank: number;

  @ApiProperty()
  userId: string;

  @ApiProperty()
  username: string;

  @ApiProperty()
  avatarUrl: string;

  @ApiProperty()
  weeklyXp: number;

  @ApiProperty()
  isCurrentUser: boolean;
}

export class RankingResponseDto {
  @ApiProperty({ enum: League })
  league: League;

  @ApiProperty()
  weekNumber: number;

  @ApiProperty({ type: [RankingEntryDto] })
  entries: RankingEntryDto[];

  @ApiProperty()
  currentUserRank?: number;

  @ApiProperty()
  promotionZone: number[];

  @ApiProperty()
  demotionZone: number[];
}
