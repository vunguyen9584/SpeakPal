import { IsUUID } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class IntentAnswerDto {
  @ApiProperty({
    description: 'Intent question ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsUUID()
  questionId: string;
}
