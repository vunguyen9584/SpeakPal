import { Test, TestingModule } from '@nestjs/testing';
import { VocabularyService } from '../vocabulary/vocabulary.service';
import { VocabularyRepository } from '../vocabulary/vocabulary.repository';
import { SrsService } from '../srs/srs.service';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { CreateVocabularyDto } from '../vocabulary/dto/create-vocabulary.dto';
import { ReviewResult } from '../vocabulary/dto/review-request.dto';
import { VocabularyQueryDto } from '../vocabulary/dto/vocabulary-query.dto';
import { Vocabulary, SRSLevel } from '@prisma/client';

describe('VocabularyService', () => {
  let service: VocabularyService;
  let repository: jest.Mocked<VocabularyRepository>;
  let srsService: jest.Mocked<SrsService>;

  const mockVocabulary: Vocabulary = {
    id: 'vocab-1',
    userId: 'user-1',
    word: 'test',
    meaning: 'a test',
    pronunciation: '/test/',
    exampleSentence: 'This is a test',
    srsLevel: 'learning' as SRSLevel,
    nextReviewDate: new Date(),
    reviewCount: 1,
    correctCount: 0,
    conversationId: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const mockRepository = {
      create: jest.fn(),
      findByUser: jest.fn(),
      findById: jest.fn(),
      findDueForReview: jest.fn(),
      updateAfterReview: jest.fn(),
      checkDuplicate: jest.fn(),
      countByUser: jest.fn(),
      delete: jest.fn(),
    };

    const mockSrsService = {
      updateLevel: jest.fn(),
      calculateNextReview: jest.fn(),
      getInterval: jest.fn(),
      isDue: jest.fn(),
      filterDueItems: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        VocabularyService,
        {
          provide: VocabularyRepository,
          useValue: mockRepository,
        },
        {
          provide: SrsService,
          useValue: mockSrsService,
        },
      ],
    }).compile();

    service = module.get<VocabularyService>(VocabularyService);
    repository = module.get(VocabularyRepository);
    srsService = module.get(SrsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('addWord', () => {
    const createDto: CreateVocabularyDto = {
      word: 'test',
      meaning: 'a test',
      pronunciation: '/test/',
      exampleSentence: 'This is a test',
    };

    it('should add a new word successfully', async () => {
      repository.checkDuplicate.mockResolvedValue(false);
      repository.create.mockResolvedValue(mockVocabulary);

      const result = await service.addWord('user-1', createDto);

      expect(repository.checkDuplicate).toHaveBeenCalledWith('user-1', 'test');
      expect(repository.create).toHaveBeenCalledWith('user-1', createDto);
      expect(result).toBeDefined();
      expect(result.word).toBe('test');
    });

    it('should throw ConflictException if word already exists', async () => {
      repository.checkDuplicate.mockResolvedValue(true);

      await expect(service.addWord('user-1', createDto)).rejects.toThrow(
        ConflictException,
      );
      expect(repository.checkDuplicate).toHaveBeenCalledWith('user-1', 'test');
      expect(repository.create).not.toHaveBeenCalled();
    });

    it('should handle word without pronunciation', async () => {
      const dtoWithoutPronunciation = {
        ...createDto,
        pronunciation: undefined,
      };

      repository.checkDuplicate.mockResolvedValue(false);
      repository.create.mockResolvedValue({
        ...mockVocabulary,
        pronunciation: '',
      });

      const result = await service.addWord('user-1', dtoWithoutPronunciation);

      expect(repository.create).toHaveBeenCalled();
      expect(result).toBeDefined();
    });

    it('should handle optional fields correctly', async () => {
      const minimalDto: CreateVocabularyDto = {
        word: 'hello',
        meaning: 'greeting',
      };

      repository.checkDuplicate.mockResolvedValue(false);
      repository.create.mockResolvedValue({
        ...mockVocabulary,
        word: 'hello',
        meaning: 'greeting',
        pronunciation: '',
        exampleSentence: null,
      });

      const result = await service.addWord('user-1', minimalDto);

      expect(result).toBeDefined();
      expect(result.word).toBe('hello');
    });
  });

  describe('listByUser', () => {
    it('should return paginated vocabulary list', async () => {
      const query: VocabularyQueryDto = {
        page: 1,
        limit: 20,
      };

      repository.findByUser.mockResolvedValue({
        data: [mockVocabulary],
        total: 1,
      });

      const result = await service.listByUser('user-1', query);

      expect(repository.findByUser).toHaveBeenCalledWith('user-1', query);
      expect(result.data).toHaveLength(1);
      expect(result.total).toBe(1);
      expect(result.page).toBe(1);
      expect(result.limit).toBe(20);
    });

    it('should handle empty results', async () => {
      const query: VocabularyQueryDto = {
        page: 1,
        limit: 20,
      };

      repository.findByUser.mockResolvedValue({
        data: [],
        total: 0,
      });

      const result = await service.listByUser('user-1', query);

      expect(result.data).toHaveLength(0);
      expect(result.total).toBe(0);
    });

    it('should use default pagination values', async () => {
      const query: VocabularyQueryDto = {};

      repository.findByUser.mockResolvedValue({
        data: [mockVocabulary],
        total: 1,
      });

      const result = await service.listByUser('user-1', query);

      expect(result.page).toBe(1);
      expect(result.limit).toBe(20);
    });

    it('should filter by SRS level', async () => {
      const query: VocabularyQueryDto = {
        srsLevel: 'learning' as SRSLevel,
        page: 1,
        limit: 20,
      };

      repository.findByUser.mockResolvedValue({
        data: [mockVocabulary],
        total: 1,
      });

      const result = await service.listByUser('user-1', query);

      expect(repository.findByUser).toHaveBeenCalledWith('user-1', query);
      expect(result.data).toHaveLength(1);
    });
  });

  describe('getDueForReview', () => {
    it('should return vocabulary items due for review', async () => {
      repository.findDueForReview.mockResolvedValue([mockVocabulary]);

      const result = await service.getDueForReview('user-1');

      expect(repository.findDueForReview).toHaveBeenCalledWith('user-1');
      expect(result).toHaveLength(1);
      expect(result[0].word).toBe('test');
    });

    it('should return empty array when no items are due', async () => {
      repository.findDueForReview.mockResolvedValue([]);

      const result = await service.getDueForReview('user-1');

      expect(result).toHaveLength(0);
    });
  });

  describe('recordReview', () => {
    const nextReviewDate = new Date();
    nextReviewDate.setDate(nextReviewDate.getDate() + 3);

    beforeEach(() => {
      srsService.updateLevel.mockReturnValue('young' as SRSLevel);
      srsService.calculateNextReview.mockReturnValue(nextReviewDate);
    });

    it('should record correct review and award 5 XP', async () => {
      repository.findById.mockResolvedValue(mockVocabulary);
      repository.updateAfterReview.mockResolvedValue({
        ...mockVocabulary,
        srsLevel: 'young' as SRSLevel,
      });

      const result = await service.recordReview(
        'user-1',
        'vocab-1',
        ReviewResult.CORRECT,
      );

      expect(repository.findById).toHaveBeenCalledWith('vocab-1');
      expect(srsService.updateLevel).toHaveBeenCalledWith(
        'learning',
        ReviewResult.CORRECT,
      );
      expect(srsService.calculateNextReview).toHaveBeenCalledWith(
        'learning',
        ReviewResult.CORRECT,
      );
      expect(repository.updateAfterReview).toHaveBeenCalledWith(
        'vocab-1',
        'young',
        nextReviewDate,
      );
      expect(result.xpEarned).toBe(5);
      expect(result.previousLevel).toBe('learning');
      expect(result.newLevel).toBe('young');
    });

    it('should record incorrect review and award 1 XP', async () => {
      repository.findById.mockResolvedValue(mockVocabulary);
      repository.updateAfterReview.mockResolvedValue(mockVocabulary);
      srsService.updateLevel.mockReturnValue('learning' as SRSLevel);

      const result = await service.recordReview(
        'user-1',
        'vocab-1',
        ReviewResult.INCORRECT,
      );

      expect(srsService.updateLevel).toHaveBeenCalledWith(
        'learning',
        ReviewResult.INCORRECT,
      );
      expect(result.xpEarned).toBe(1);
      expect(result.previousLevel).toBe('learning');
      expect(result.newLevel).toBe('learning');
    });

    it('should throw NotFoundException if vocabulary not found', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(
        service.recordReview('user-1', 'vocab-1', ReviewResult.CORRECT),
      ).rejects.toThrow(NotFoundException);

      expect(repository.updateAfterReview).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException if user does not own vocabulary', async () => {
      repository.findById.mockResolvedValue({
        ...mockVocabulary,
        userId: 'other-user',
      });

      await expect(
        service.recordReview('user-1', 'vocab-1', ReviewResult.CORRECT),
      ).rejects.toThrow(NotFoundException);

      expect(repository.updateAfterReview).not.toHaveBeenCalled();
    });

    it('should update review count and next review date', async () => {
      repository.findById.mockResolvedValue(mockVocabulary);
      repository.updateAfterReview.mockResolvedValue({
        ...mockVocabulary,
        reviewCount: 2,
        correctCount: 1,
      });

      const result = await service.recordReview(
        'user-1',
        'vocab-1',
        ReviewResult.CORRECT,
      );

      expect(result.nextReviewDate).toEqual(nextReviewDate);
    });
  });

  describe('getById', () => {
    it('should return vocabulary by id', async () => {
      repository.findById.mockResolvedValue(mockVocabulary);

      const result = await service.getById('user-1', 'vocab-1');

      expect(repository.findById).toHaveBeenCalledWith('vocab-1');
      expect(result.word).toBe('test');
    });

    it('should throw NotFoundException if vocabulary not found', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.getById('user-1', 'vocab-1')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw NotFoundException if user does not own vocabulary', async () => {
      repository.findById.mockResolvedValue({
        ...mockVocabulary,
        userId: 'other-user',
      });

      await expect(service.getById('user-1', 'vocab-1')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('deleteWord', () => {
    it('should delete vocabulary successfully', async () => {
      repository.findById.mockResolvedValue(mockVocabulary);
      repository.delete.mockResolvedValue(undefined);

      await service.deleteWord('user-1', 'vocab-1');

      expect(repository.findById).toHaveBeenCalledWith('vocab-1');
      expect(repository.delete).toHaveBeenCalledWith('vocab-1');
    });

    it('should throw NotFoundException if vocabulary not found', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.deleteWord('user-1', 'vocab-1')).rejects.toThrow(
        NotFoundException,
      );
      expect(repository.delete).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException if user does not own vocabulary', async () => {
      repository.findById.mockResolvedValue({
        ...mockVocabulary,
        userId: 'other-user',
      });

      await expect(service.deleteWord('user-1', 'vocab-1')).rejects.toThrow(
        NotFoundException,
      );
      expect(repository.delete).not.toHaveBeenCalled();
    });
  });

  describe('countByUser', () => {
    it('should return count of vocabulary for user', async () => {
      repository.countByUser.mockResolvedValue(42);

      const result = await service.countByUser('user-1');

      expect(repository.countByUser).toHaveBeenCalledWith('user-1');
      expect(result).toBe(42);
    });

    it('should return 0 when user has no vocabulary', async () => {
      repository.countByUser.mockResolvedValue(0);

      const result = await service.countByUser('user-1');

      expect(result).toBe(0);
    });
  });

  describe('XP Calculation Tests', () => {
    const nextReviewDate = new Date();

    beforeEach(() => {
      repository.findById.mockResolvedValue(mockVocabulary);
      repository.updateAfterReview.mockResolvedValue(mockVocabulary);
      srsService.calculateNextReview.mockReturnValue(nextReviewDate);
    });

    it('should award 5 XP for correct review at all levels', async () => {
      const levels: SRSLevel[] = ['new', 'learning', 'young', 'mature', 'mastered'];

      for (const level of levels) {
        repository.findById.mockResolvedValue({
          ...mockVocabulary,
          srsLevel: level,
        });
        srsService.updateLevel.mockReturnValue(level);

        const result = await service.recordReview(
          'user-1',
          'vocab-1',
          ReviewResult.CORRECT,
        );

        expect(result.xpEarned).toBe(5);
      }
    });

    it('should award 1 XP for incorrect review at all levels', async () => {
      const levels: SRSLevel[] = ['new', 'learning', 'young', 'mature', 'mastered'];

      for (const level of levels) {
        repository.findById.mockResolvedValue({
          ...mockVocabulary,
          srsLevel: level,
        });
        srsService.updateLevel.mockReturnValue(level);

        const result = await service.recordReview(
          'user-1',
          'vocab-1',
          ReviewResult.INCORRECT,
        );

        expect(result.xpEarned).toBe(1);
      }
    });
  });

  describe('Integration Test Scenarios', () => {
    it('should handle full vocabulary lifecycle', async () => {
      // 1. Add word
      repository.checkDuplicate.mockResolvedValue(false);
      repository.create.mockResolvedValue(mockVocabulary);

      const added = await service.addWord('user-1', {
        word: 'test',
        meaning: 'a test',
      });

      expect(added).toBeDefined();

      // 2. Get word
      repository.findById.mockResolvedValue(mockVocabulary);
      const retrieved = await service.getById('user-1', 'vocab-1');
      expect(retrieved.word).toBe('test');

      // 3. Review word
      srsService.updateLevel.mockReturnValue('young' as SRSLevel);
      srsService.calculateNextReview.mockReturnValue(new Date());
      repository.updateAfterReview.mockResolvedValue({
        ...mockVocabulary,
        srsLevel: 'young' as SRSLevel,
      });

      const review = await service.recordReview(
        'user-1',
        'vocab-1',
        ReviewResult.CORRECT,
      );
      expect(review.xpEarned).toBe(5);

      // 4. Delete word
      repository.delete.mockResolvedValue(undefined);
      await service.deleteWord('user-1', 'vocab-1');
      expect(repository.delete).toHaveBeenCalled();
    });
  });
});
