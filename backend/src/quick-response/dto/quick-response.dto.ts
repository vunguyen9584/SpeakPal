import { IsEnum, IsOptional, IsNumber, Min, Max } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PracticeType } from '@prisma/client';

export class StartQuickResponseSessionDto {
  @ApiProperty({
    description: 'Practice type',
    enum: [PracticeType.WORD_ASSOCIATION, PracticeType.INSTANT_DRILL],
    example: PracticeType.WORD_ASSOCIATION,
  })
  @IsEnum([PracticeType.WORD_ASSOCIATION, PracticeType.INSTANT_DRILL])
  practiceType: PracticeType;

  @ApiPropertyOptional({
    description: 'Difficulty level (1-5)',
    example: 3,
  })
  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(5)
  difficulty?: number;
}

export class SubmitQuickResponseDto {
  @ApiProperty({
    description: 'Session ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  sessionId: string;

  @ApiProperty({
    description: 'Total score (0-100)',
    example: 85,
  })
  @IsNumber()
  @Min(0)
  @Max(100)
  totalScore: number;

  @ApiProperty({
    description: 'Number of correct answers',
    example: 8,
  })
  @IsNumber()
  @Min(0)
  correctCount: number;

  @ApiProperty({
    description: 'Maximum chain achieved',
    example: 5,
  })
  @IsNumber()
  @Min(0)
  maxChain: number;

  @ApiProperty({
    description: 'Session duration in seconds',
    example: 120,
  })
  @IsNumber()
  @Min(0)
  durationSec: number;

  @ApiPropertyOptional({
    description: 'Detailed session data',
  })
  @IsOptional()
  details?: any;
}

export class QuickResponseResultDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  practiceType: PracticeType;

  @ApiProperty()
  totalScore: number;

  @ApiProperty()
  correctCount: number;

  @ApiProperty()
  maxChain: number;

  @ApiProperty()
  xpEarned: number;

  @ApiProperty()
  streakBonus: boolean;
}
