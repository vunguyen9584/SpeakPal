import { Test, TestingModule } from '@nestjs/testing';
import { SrsService } from './srs.service';
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

  describe('updateLevel', () => {
    it('should promote level on correct review', () => {
      const result = service.updateLevel(SrsLevel.NEW, ReviewResult.CORRECT);
      expect(result).toBe(SrsLevel.LEARNING);
    });

    it('should demote level on incorrect review', () => {
      const result = service.updateLevel(SrsLevel.YOUNG, ReviewResult.INCORRECT);
      expect(result).toBe(SrsLevel.LEARNING);
    });

    it('should not go below LEARNING on incorrect', () => {
      const result = service.updateLevel(SrsLevel.LEARNING, ReviewResult.INCORRECT);
      expect(result).toBe(SrsLevel.LEARNING);
    });

    it('should max out at MASTERED', () => {
      const result = service.updateLevel(SrsLevel.MASTERED, ReviewResult.CORRECT);
      expect(result).toBe(SrsLevel.MASTERED);
    });
  });

  describe('calculateNextReview', () => {
    it('should calculate future date based on interval', () => {
      const result = service.calculateNextReview(SrsLevel.NEW, ReviewResult.CORRECT);
      const now = new Date();
      expect(result.getTime()).toBeGreaterThan(now.getTime());
    });
  });

  describe('isDue', () => {
    it('should be true for past dates', () => {
      const past = new Date();
      past.setDate(past.getDate() - 1);
      expect(service.isDue(past)).toBe(true);
    });

    it('should be false for future dates', () => {
      const future = new Date();
      future.setDate(future.getDate() + 1);
      expect(service.isDue(future)).toBe(false);
    });
  });
});
