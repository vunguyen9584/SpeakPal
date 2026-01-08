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
      expect(service.getInterval(SrsLevel.NEW)).toBe(0);
    });

    it('should return 1 day for learning level', () => {
      expect(service.getInterval(SrsLevel.LEARNING)).toBe(1);
    });

    it('should return 3 days for young level', () => {
      expect(service.getInterval(SrsLevel.YOUNG)).toBe(3);
    });

    it('should return 7 days for mature level', () => {
      expect(service.getInterval(SrsLevel.MATURE)).toBe(7);
    });

    it('should return 30 days for mastered level', () => {
      expect(service.getInterval(SrsLevel.MASTERED)).toBe(30);
    });
  });

  describe('updateLevel - Correct Answers', () => {
    it('should upgrade from new to learning on correct', () => {
      const result = service.updateLevel(SrsLevel.NEW, ReviewResult.CORRECT);
      expect(result).toBe(SrsLevel.LEARNING);
    });

    it('should upgrade from learning to young on correct', () => {
      const result = service.updateLevel(
        SrsLevel.LEARNING,
        ReviewResult.CORRECT,
      );
      expect(result).toBe(SrsLevel.YOUNG);
    });

    it('should upgrade from young to mature on correct', () => {
      const result = service.updateLevel(SrsLevel.YOUNG, ReviewResult.CORRECT);
      expect(result).toBe(SrsLevel.MATURE);
    });

    it('should upgrade from mature to mastered on correct', () => {
      const result = service.updateLevel(SrsLevel.MATURE, ReviewResult.CORRECT);
      expect(result).toBe(SrsLevel.MASTERED);
    });

    it('should stay at mastered on correct (edge case)', () => {
      const result = service.updateLevel(
        SrsLevel.MASTERED,
        ReviewResult.CORRECT,
      );
      expect(result).toBe(SrsLevel.MASTERED);
    });
  });

  describe('updateLevel - Incorrect Answers', () => {
    it('should downgrade from mastered to mature on incorrect', () => {
      const result = service.updateLevel(
        SrsLevel.MASTERED,
        ReviewResult.INCORRECT,
      );
      expect(result).toBe(SrsLevel.MATURE);
    });

    it('should downgrade from mature to young on incorrect', () => {
      const result = service.updateLevel(
        SrsLevel.MATURE,
        ReviewResult.INCORRECT,
      );
      expect(result).toBe(SrsLevel.YOUNG);
    });

    it('should downgrade from young to learning on incorrect', () => {
      const result = service.updateLevel(
        SrsLevel.YOUNG,
        ReviewResult.INCORRECT,
      );
      expect(result).toBe(SrsLevel.LEARNING);
    });

    it('should stay at learning on incorrect (minimum level)', () => {
      const result = service.updateLevel(
        SrsLevel.LEARNING,
        ReviewResult.INCORRECT,
      );
      expect(result).toBe(SrsLevel.LEARNING);
    });

    it('should move to learning from new on incorrect', () => {
      const result = service.updateLevel(SrsLevel.NEW, ReviewResult.INCORRECT);
      expect(result).toBe(SrsLevel.LEARNING);
    });
  });

  describe('calculateNextReview', () => {
    it('should calculate next review date for new level with correct answer', () => {
      const currentLevel: SrsLevel = SrsLevel.NEW;
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
      const currentLevel: SrsLevel = SrsLevel.LEARNING;
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 3); // young = 3 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for young level with correct answer', () => {
      const currentLevel: SrsLevel = SrsLevel.YOUNG;
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 7); // mature = 7 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for mature level with correct answer', () => {
      const currentLevel: SrsLevel = SrsLevel.MATURE;
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 30); // mastered = 30 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for mastered level with correct answer', () => {
      const currentLevel: SrsLevel = SrsLevel.MASTERED;
      const result = ReviewResult.CORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 30); // mastered stays = 30 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for mature level with incorrect answer', () => {
      const currentLevel: SrsLevel = SrsLevel.MATURE;
      const result = ReviewResult.INCORRECT;
      const nextDate = service.calculateNextReview(currentLevel, result);

      const expectedDate = new Date();
      expectedDate.setDate(expectedDate.getDate() + 3); // downgrade to young = 3 days

      expect(
        Math.abs(nextDate.getTime() - expectedDate.getTime()),
      ).toBeLessThan(1000);
    });

    it('should calculate next review date for learning level with incorrect answer', () => {
      const currentLevel: SrsLevel = SrsLevel.LEARNING;
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
      let currentLevel: SrsLevel = SrsLevel.NEW;

      // new -> learning
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.LEARNING);

      // learning -> young
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.YOUNG);

      // young -> mature
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.MATURE);

      // mature -> mastered
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.MASTERED);

      // mastered -> mastered (stays)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.MASTERED);
    });

    it('should handle full regression from mastered to learning', () => {
      let currentLevel: SrsLevel = SrsLevel.MASTERED;

      // mastered -> mature
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe(SrsLevel.MATURE);

      // mature -> young
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe(SrsLevel.YOUNG);

      // young -> learning
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe(SrsLevel.LEARNING);

      // learning -> learning (stays)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe(SrsLevel.LEARNING);
    });

    it('should handle mixed correct and incorrect answers', () => {
      let currentLevel: SrsLevel = SrsLevel.LEARNING;

      // learning -> young (correct)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.YOUNG);

      // young -> learning (incorrect)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.INCORRECT);
      expect(currentLevel).toBe(SrsLevel.LEARNING);

      // learning -> young (correct)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.YOUNG);

      // young -> mature (correct)
      currentLevel = service.updateLevel(currentLevel, ReviewResult.CORRECT);
      expect(currentLevel).toBe(SrsLevel.MATURE);
    });
  });
});
