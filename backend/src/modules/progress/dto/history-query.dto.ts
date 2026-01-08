import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class HistoryQueryDto {
  @ApiPropertyOptional()
  @IsOptional()
  startDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  endDate?: string;

  @ApiPropertyOptional({
    enum: ['conversation', 'vocabulary_review', 'challenge'],
  })
  @IsOptional()
  type?: 'conversation' | 'vocabulary_review' | 'challenge';

  @ApiPropertyOptional({ minimum: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ minimum: 1, default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number = 20;
}

export class HistoryItemDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: ['conversation', 'vocabulary_review', 'challenge'] })
  type: string;

  @ApiProperty()
  timestamp: Date;

  @ApiPropertyOptional()
  duration?: number;

  @ApiProperty()
  xpEarned: number;

  @ApiProperty()
  details: Record<string, unknown>;
}

export class HistoryResponseDto {
  @ApiProperty({ type: [HistoryItemDto] })
  data: HistoryItemDto[];

  @ApiProperty()
  total: number;

  @ApiProperty()
  page: number;

  @ApiProperty()
  limit: number;
}
