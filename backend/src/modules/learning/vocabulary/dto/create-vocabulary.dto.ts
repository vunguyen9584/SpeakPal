import { IsString, IsOptional, IsUUID, Length } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateVocabularyDto {
  @ApiProperty({ example: 'hello', description: 'The word to save' })
  @IsString()
  @Length(1, 100)
  word: string;

  @ApiProperty({ example: 'こんにちは', description: 'Meaning in Japanese' })
  @IsString()
  @Length(1, 500)
  meaning: string;

  @ApiPropertyOptional({ example: '/həˈloʊ/', description: 'IPA pronunciation' })
  @IsOptional()
  @IsString()
  pronunciation?: string;

  @ApiPropertyOptional({
    example: 'Hello, how are you?',
    description: 'Example sentence',
  })
  @IsOptional()
  @IsString()
  exampleSentence?: string;

  @ApiPropertyOptional({ description: 'Conversation ID where this word was encountered' })
  @IsOptional()
  @IsUUID()
  conversationId?: string;
}
