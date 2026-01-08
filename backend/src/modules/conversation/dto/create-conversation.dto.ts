import {
  IsEnum,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { ConversationMode } from '@prisma/client';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateConversationDto {
  @ApiProperty({
    enum: ConversationMode,
    description: 'Conversation mode',
  })
  @IsEnum(ConversationMode)
  mode: ConversationMode;

  @ApiPropertyOptional({ description: 'Persona ID for the conversation' })
  @IsOptional()
  @IsUUID()
  personaId?: string;

  @ApiPropertyOptional({ description: 'Scenario ID for roleplay mode' })
  @IsOptional()
  @IsUUID()
  scenarioId?: string;

  @ApiPropertyOptional({
    description: 'Topic for conversation (max 100 chars)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  topic?: string;
}
