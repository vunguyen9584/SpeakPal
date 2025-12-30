import { Injectable } from '@nestjs/common';
import { SRSLevel } from '@prisma/client';
import { SRS_INTERVALS, SRS_LEVEL_ORDER } from './srs.constants';
import { ReviewResult } from '../vocabulary/dto/review-request.dto';

@Injectable()
export class SrsService {
  /**
   * Get the interval in days for a given SRS level
   */
  getInterval(level: SRSLevel): number {
    return SRS_INTERVALS[level];
  }

  /**
   * Calculate the next review date based on current SRS item and review result
   */
  calculateNextReview(currentLevel: SRSLevel, result: ReviewResult): Date {
    const newLevel = this.updateLevel(currentLevel, result);
    const interval = this.getInterval(newLevel);
    const nextDate = new Date();
    nextDate.setDate(nextDate.getDate() + interval);
    return nextDate;
  }

  /**
   * Update SRS level based on review result
   * Correct answer: move up one level
   * Incorrect answer: move down one level (but not below 'learning')
   */
  updateLevel(current: SRSLevel, result: ReviewResult): SRSLevel {
    const currentIndex = SRS_LEVEL_ORDER.indexOf(current);

    if (result === ReviewResult.CORRECT) {
      // Move up one level, but max out at 'mastered'
      if (current === 'mastered') {
        return 'mastered';
      }
      return SRS_LEVEL_ORDER[currentIndex + 1];
    } else {
      // Move down one level on incorrect, but minimum is 'learning'
      switch (current) {
        case 'mastered':
          return 'mature';
        case 'mature':
          return 'young';
        case 'young':
          return 'learning';
        case 'learning':
          return 'learning';
        case 'new':
          return 'learning';
        default:
          return 'learning';
      }
    }
  }

  /**
   * Check if a vocabulary item is due for review
   */
  isDue(nextReviewDate: Date): boolean {
    return new Date() >= nextReviewDate;
  }

  /**
   * Get all due items from a list
   */
  filterDueItems<T extends { nextReviewDate: Date }>(items: T[]): T[] {
    return items.filter((item) => this.isDue(item.nextReviewDate));
  }
}
