import { IsEnum, IsOptional, IsString } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Level } from '@prisma/client';

export class GetTranslationQuestionQueryDto {
  @ApiProperty({
    description: 'Topic for translation question',
    enum: ['daily', 'business', 'travel', 'news', 'entertainment'],
    example: 'daily',
  })
  @IsEnum(['daily', 'business', 'travel', 'news', 'entertainment'])
  topic: string;

  @ApiPropertyOptional({
    description:
      'User level (optional, will use user profile level if not provided)',
    enum: Level,
    example: Level.BEGINNER,
  })
  @IsOptional()
  @IsEnum(Level)
  level?: Level;
}
