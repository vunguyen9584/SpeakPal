import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TurnSpeaker } from '@prisma/client';
import { CorrectionDto } from './conversation-summary.dto';

export class TurnDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: TurnSpeaker })
  speaker: TurnSpeaker;

  @ApiProperty()
  content: string;

  @ApiProperty()
  sequence: number;

  @ApiPropertyOptional({ type: [CorrectionDto] })
  corrections?: CorrectionDto[];

  @ApiProperty()
  createdAt: Date;

  constructor(partial: Partial<TurnDto>) {
    Object.assign(this, partial);
  }
}
