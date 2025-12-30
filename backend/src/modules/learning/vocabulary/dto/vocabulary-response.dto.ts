import { ApiProperty } from '@nestjs/swagger';
import { SRSLevel } from '@prisma/client';

export class VocabularyResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  word: string;

  @ApiProperty()
  meaning: string;

  @ApiProperty()
  pronunciation: string;

  @ApiProperty({ nullable: true })
  exampleSentence: string | null;

  @ApiProperty({ enum: SRSLevel })
  srsLevel: SRSLevel;

  @ApiProperty()
  nextReviewDate: Date;

  @ApiProperty()
  reviewCount: number;

  @ApiProperty()
  correctCount: number;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty({ nullable: true })
  conversationId: string | null;

  static fromEntity(vocab: any): VocabularyResponseDto {
    const dto = new VocabularyResponseDto();
    dto.id = vocab.id;
    dto.word = vocab.word;
    dto.meaning = vocab.meaning;
    dto.pronunciation = vocab.pronunciation;
    dto.exampleSentence = vocab.exampleSentence;
    dto.srsLevel = vocab.srsLevel;
    dto.nextReviewDate = vocab.nextReviewDate;
    dto.reviewCount = vocab.reviewCount;
    dto.correctCount = vocab.correctCount;
    dto.createdAt = vocab.createdAt;
    dto.conversationId = vocab.conversationId;
    return dto;
  }
}
