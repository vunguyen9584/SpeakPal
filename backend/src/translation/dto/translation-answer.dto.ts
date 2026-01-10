import { IsUUID, IsNumber, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

export class TranslationAnswerDto {
  @ApiProperty({
    description: 'Translation question ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsUUID()
  questionId: string;

  @ApiProperty({
    description: 'Response time in seconds',
    example: 8.5,
    minimum: 0,
    maximum: 60,
  })
  @IsNumber()
  @Type(() => Number)
  @Min(0)
  @Max(60)
  responseTimeSec: number;
}
