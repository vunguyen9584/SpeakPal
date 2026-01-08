import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { VocabularyRepository } from './vocabulary.repository';
import { SrsService } from '../srs/srs.service';
import { CreateVocabularyDto } from './dto/create-vocabulary.dto';
import { VocabularyQueryDto } from './dto/vocabulary-query.dto';
import { ReviewResult, ReviewResponseDto } from './dto/review-request.dto';
import { VocabularyResponseDto } from './dto/vocabulary-response.dto';
import { Vocabulary } from '@prisma/client';

@Injectable()
export class VocabularyService {
  constructor(
    private readonly repository: VocabularyRepository,
    private readonly srsService: SrsService,
  ) {}

  async addWord(
    userId: string,
    dto: CreateVocabularyDto,
  ): Promise<VocabularyResponseDto> {
    // Check for duplicate
    const isDuplicate = await this.repository.checkDuplicate(userId, dto.word);
    if (isDuplicate) {
      throw new ConflictException(
        'This word already exists in your vocabulary',
      );
    }

    // TODO: Auto-fetch pronunciation if empty (integrate with external API)
    // For now, we'll use empty string as placeholder
    if (!dto.pronunciation) {
      dto.pronunciation = ''; // Placeholder
    }

    const vocabulary = await this.repository.create(userId, dto);
    return VocabularyResponseDto.fromEntity(vocabulary);
  }

  async listByUser(
    userId: string,
    query: VocabularyQueryDto,
  ): Promise<{
    data: VocabularyResponseDto[];
    total: number;
    page: number;
    limit: number;
  }> {
    const { data, total } = await this.repository.findByUser(userId, query);
    return {
      data: data.map(VocabularyResponseDto.fromEntity),
      total,
      page: query.page || 1,
      limit: query.limit || 20,
    };
  }

  async getDueForReview(userId: string): Promise<VocabularyResponseDto[]> {
    const dueItems = await this.repository.findDueForReview(userId);
    return dueItems.map(VocabularyResponseDto.fromEntity);
  }

  async recordReview(
    userId: string,
    vocabularyId: string,
    result: ReviewResult,
  ): Promise<ReviewResponseDto> {
    const vocab = await this.repository.findById(vocabularyId);
    if (!vocab) {
      throw new NotFoundException('Vocabulary not found');
    }

    // Ensure user owns this vocabulary
    if (vocab.userId !== userId) {
      throw new NotFoundException('Vocabulary not found');
    }

    const previousLevel = vocab.srsLevel;
    const newLevel = this.srsService.updateLevel(vocab.srsLevel, result);
    const nextDate = this.srsService.calculateNextReview(
      vocab.srsLevel,
      result,
    );

    await this.repository.updateAfterReview(vocabularyId, newLevel, nextDate);

    // Calculate XP: correct = 5, incorrect = 1
    const xpEarned = result === ReviewResult.CORRECT ? 5 : 1;

    return {
      previousLevel,
      newLevel,
      nextReviewDate: nextDate,
      xpEarned,
    };
  }

  async getById(userId: string, id: string): Promise<VocabularyResponseDto> {
    const vocab = await this.repository.findById(id);
    if (!vocab || vocab.userId !== userId) {
      throw new NotFoundException('Vocabulary not found');
    }
    return VocabularyResponseDto.fromEntity(vocab);
  }

  async deleteWord(userId: string, id: string): Promise<void> {
    const vocab = await this.repository.findById(id);
    if (!vocab || vocab.userId !== userId) {
      throw new NotFoundException('Vocabulary not found');
    }
    await this.repository.delete(id);
  }

  async countByUser(userId: string): Promise<number> {
    return this.repository.countByUser(userId);
  }
}
