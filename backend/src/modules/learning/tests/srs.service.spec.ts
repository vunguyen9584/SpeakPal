import { Test, TestingModule } from '@nestjs/testing';
import { SrsService } from '../srs/srs.service';
import { SrsLevel } from '@prisma/client';
import { ReviewResult } from '../vocabulary/dto/review-request.dto';

describe('SrsService', () => {
  let service: SrsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [SrsService],
    }).compile();

    service = module.get<SrsService>(SrsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getInterval', () => {
    it('should return 0 days for new level', () => {
      expect(service.getInterval('new')).toBe(0);
    });

    it('should return 1 day for learning level', () => {
      expect(service.getInterval('learning')).toBe(1);
    });

    it('should return 3 days for young level', () => {
      expect(service.getInterval('young')).toBe(3);
    });

    it('should return 7 days for mature level', () => {
      expect(service.getInterval('mature')).toBe(7);
    });

    it('should return 30 days for mastered level', () => {
      expect(service.getInterval('mastered')).toBe(30);
    });
  });

  describe('updateLevel - Correct Answers', () => {
    it('should upgrade from new to learning on correct', () => {
      const result = service.updateLevel('new', ReviewResult.CORRECT);
      expect(result).toBe('learning');
    });

    it('should upgrade from learning to young on correct', () => {
      const result = service.updateLevel('learning', ReviewResult.CORRECT);
      expect(result).toBe('young');
    });

    it('should upgrade from young to mature on correct', () => {
      const result = service.updateLevel('young', ReviewResult.CORRECT);
      expect(result).toBe('mature');
    });

    it('should upgrade from mature to mastered on correct', () => {
      const result = service.updateLevel('mature', ReviewResult.CORRECT);
      expect(result).toBe('mastered');
    });

    it('should stay at mastered on correct (edge case)', () => {
      const result = service.updateLevel('mastered', ReviewResult.CORRECT);
      expect(result).toBe('mastered');
    });
  });

  describe('updateLevel - Incorrect Answers', () => {
    it('should downgrade from mastered to mature on incorrect', () => {
      const result = service.updateLevel('mastered', ReviewResult.INCORRECT);
      expect(result).toBe('mature');
    });

    it('should downgrade from mature to young on incorrect', () => {
      const result = service.updateLevel('mature', ReviewResult.INCORRECT);
      expect(result).toBe('young');
    });

    it('should downgrade from young to learning on incorrect', () => {
      const result = service.updateLevel('young', ReviewResult.INCORRECT);
      expect(result).toBe('learning');
    });

    it('should stay at learning on incorrect (minimum level)', () => {
      const result = service.updateLevel('learning', ReviewResult.INCORRECT);
      expect(result).toBe('learning');
    });

    it('should move to learning from new on incorrect', () => {
      const result = service.updateLevel('new', ReviewResult.INCORRECT);
      expect(result).toBe('learning');
    });
  });

  describe('calculateNextReview', () => {
    it('should calculate next review date for new level with correct answer', () => {
      const currentLevel: SrsLevel = 'new';
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 1); // learning = 1 day

      // Compare dates (within 1 second tolerance)
      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for learning level with correct answer', () => {
      const currentLevel: SrsLevel = 'learning';
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 3); // young = 3 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for young level with correct answer', () => {
      const currentLevel: SrsLevel = 'young';
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 7); // mature = 7 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for mature level with correct answer', () => {
      const currentLevel: SrsLevel = 'mature';
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 30); // mastered = 30 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for mastered level with correct answer', () => {
      const currentLevel: SrsLevel = 'mastered';
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 30); // mastered stays = 30 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for mature level with incorrect answer', () => {
      const currentLevel: SrsLevel = 'mature';
      const result = ReviewResult.INCORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 3); // downgrade to young = 3 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for learning level with incorrect answer', () => {
      const currentLevel: SrsLevel = 'learning';
      const result = ReviewResult.INCORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 1); // stays at learning = 1 day

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });
  });

  describe('isDue', () => {
    it('should return true for past dates', () => {
      const pastDate = new Date();
      pastDate.setDate(pastDate.getDate() - 1);
      expect(service.isDue(pastDate)).toBe(true);
    });

    it('should return true for current date', () => {
      const now = new Date();
      expect(service.isDue(now)).toBe(true);
    });

    it('should return false for future dates', () => {
      const futureDate = new Date();
      futureDate.setDate(futureDate.getDate() + 1);
      expect(service.isDue(futureDate)).toBe(false);
    });
  });

  describe('filterDueItems', () => {
    it('should filter out items not due for review', () => {
      const pastDate = new Date();
      pastDate.setDate(pastDate.getDate() - 1);

      const futureDate = new Date();
      futureDate.setDate(futureDate.getDate() + 1);

      const items = [
        { id: '1', nextReviewDate: pastDate },
        { id: '2', nextReviewDate: futureDate },
        { id: '3', nextReviewDate: new Date() },
      ];

      const dueItems = service.filterDueItems(items);
      expect(dueItems).toHaveLength(2);
      expect(dueItems.map((i) => i.id)).toEqual(['1', '3']);
    });

    it('should return empty array when no items are due', () => {
      const futureDate = new Date();
      futureDate.setDate(futureDate.getDate() + 1);

      const items = [
        { id: '1', nextReviewDate: futureDate },
        { id: '2', nextReviewDate: futureDate },
      ];

      const dueItems = service.filterDueItems(items);
      expect(dueItems).toHaveLength(0);
    });

    it('should return all items when all are due', () => {
      const pastDate = new Date();
      pastDate.setDate(pastDate.getDate() - 1);

      const items = [
        { id: '1', nextReviewDate: pastDate },
        { id: '2', nextReviewDate: pastDate },
        { id: '3', nextReviewDate: pastDate },
      ];

      const dueItems = service.filterDueItems(items);
      expect(dueItems).toHaveLength(3);
    });
  });

  describe('Edge Cases and Full Cycle Tests', () => {
    it('should handle full progression from new to mastered', () => {
      let currentLevel: SrsLevel = 'new';

      // new -> learning
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('learning');

      // learning -> young
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('young');

      // young -> mature
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('mature');

      // mature -> mastered
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('mastered');

      // mastered -> mastered (stays)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('mastered');
    });

    it('should handle full regression from mastered to learning', () => {
      let currentLevel: SrsLevel = 'mastered';

      // mastered -> mature
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe('mature');

      // mature -> young
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe('young');

      // young -> learning
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe('learning');

      // learning -> learning (stays)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe('learning');
    });

    it('should handle mixed correct and incorrect answers', () => {
      let currentLevel: SrsLevel = 'learning';

      // learning -> young (correct)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('young');

      // young -> learning (incorrect)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe('learning');

      // learning -> young (correct)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('young');

      // young -> mature (correct)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe('mature');
    });
  });
});
