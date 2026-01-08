import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ConversationMode } from '@prisma/client';

export class PersonaResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  name: string;

  @ApiPropertyOptional()
  avatar?: string;
}

export class ConversationResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  mode: ConversationMode;

  @ApiProperty()
  status: 'active' | 'ended';

  @ApiProperty()
  websocketUrl: string;

  @ApiProperty()
  token: string;

  @ApiPropertyOptional()
  persona?: PersonaResponseDto;

  @ApiPropertyOptional()
  topic?: string;

  @ApiProperty()
  startedAt: Date;

  constructor(partial: Partial<ConversationResponseDto>) {
    Object.assign(this, partial);
  }
}
