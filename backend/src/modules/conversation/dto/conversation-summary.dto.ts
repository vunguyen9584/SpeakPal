import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CorrectionDto {
  @ApiProperty()
  type: string;

  @ApiProperty()
  original: string;

  @ApiProperty()
  corrected: string;

  @ApiProperty()
  explanation: string;

  @ApiProperty()
  severity: string;
}

export class ConversationSummaryDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  summary: string;

  @ApiProperty()
  durationSeconds: number;

  @ApiProperty()
  pronunciationScore: number;

  @ApiProperty()
  xpEarned: number;

  @ApiProperty()
  corrections: CorrectionDto[];

  @ApiPropertyOptional()
  levelUp?: boolean;

  @ApiPropertyOptional()
  newLevel?: number;

  @ApiPropertyOptional()
  newBadges?: string[];

  constructor(partial: Partial<ConversationSummaryDto>) {
    Object.assign(this, partial);
  }
}
