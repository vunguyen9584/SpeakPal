import {
  IsEnum,
  IsOptional,
  IsUUID,
  IsNumber,
  Min,
  Max,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Level, ContentType } from '@prisma/client';

export class GetShadowingContentQueryDto {
  @ApiProperty({
    description: 'Content type',
    enum: ContentType,
    example: ContentType.CONVERSATION,
  })
  @IsEnum(ContentType)
  contentType: ContentType;

  @ApiPropertyOptional({
    description: 'User level',
    enum: Level,
  })
  @IsOptional()
  @IsEnum(Level)
  level?: Level;
}

export class SubmitShadowingResultDto {
  @ApiProperty({
    description: 'Shadowing content ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsUUID()
  contentId: string;

  @ApiProperty({
    description: 'Following score (0-100)',
    example: 85,
  })
  @IsNumber()
  @Min(0)
  @Max(100)
  followingScore: number;

  @ApiProperty({
    description: 'Pronunciation score (0-100)',
    example: 78,
  })
  @IsNumber()
  @Min(0)
  @Max(100)
  pronunciationScore: number;

  @ApiProperty({
    description: 'Rhythm score (0-100)',
    example: 82,
  })
  @IsNumber()
  @Min(0)
  @Max(100)
  rhythmScore: number;

  @ApiProperty({
    description: 'Practice duration in seconds',
    example: 120,
  })
  @IsNumber()
  @Min(0)
  durationSec: number;

  @ApiPropertyOptional({
    description: 'Detailed analysis data',
  })
  @IsOptional()
  details?: any;
}

export class ShadowingContentResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  contentType: ContentType;

  @ApiProperty()
  title: string;

  @ApiProperty()
  description: string;

  @ApiProperty()
  level: Level;

  @ApiProperty()
  transcript: string;

  @ApiProperty()
  audioUrl: string;

  @ApiProperty()
  timestamps: any[];

  @ApiProperty()
  durationSec: number;

  @ApiProperty()
  isPremium: boolean;

  @ApiProperty()
  thumbnailUrl: string;
}

export class ShadowingResultResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  totalScore: number;

  @ApiProperty()
  followingScore: number;

  @ApiProperty()
  pronunciationScore: number;

  @ApiProperty()
  rhythmScore: number;

  @ApiProperty()
  xpEarned: number;

  @ApiProperty()
  streakBonus: boolean;

  @ApiProperty()
  feedback: any;
}
