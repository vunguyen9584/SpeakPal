import { IsEnum, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Level } from '@prisma/client';

export class GetIntentQuestionQueryDto {
  @ApiProperty({
    description: 'Category for intent question',
    enum: ['greeting', 'daily', 'business', 'emotion', 'request'],
    example: 'business',
  })
  @IsEnum(['greeting', 'daily', 'business', 'emotion', 'request'])
  category: string;

  @ApiPropertyOptional({
    description: 'User level (optional)',
    enum: Level,
  })
  @IsOptional()
  @IsEnum(Level)
  level?: Level;
}
