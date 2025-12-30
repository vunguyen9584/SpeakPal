import { IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export enum ReviewResult {
  CORRECT = 'correct',
  INCORRECT = 'incorrect',
}

export class ReviewRequestDto {
  @ApiProperty({ enum: ReviewResult, example: ReviewResult.CORRECT })
  @IsEnum(ReviewResult)
  result: ReviewResult;
}

export class ReviewResponseDto {
  @ApiProperty()
  previousLevel: string;

  @ApiProperty()
  newLevel: string;

  @ApiProperty()
  nextReviewDate: Date;

  @ApiProperty()
  xpEarned: number;
}
