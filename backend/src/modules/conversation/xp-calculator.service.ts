import { Injectable } from '@nestjs/common';

export interface XPCalculationResult {
  baseXP: number;
  bonusXP: number;
  streakMultiplier: number;
  totalXP: number;
}

@Injectable()
export class XPCalculatorService {
  /**
   * Calculate XP earned from a conversation
   * @param durationMinutes Duration of conversation in minutes
   * @param pronunciationScore Pronunciation score (0-100)
   * @param currentStreak Current streak days
   * @returns XP calculation breakdown
   */
  calculate(
    durationMinutes: number,
    pronunciationScore: number,
    currentStreak: number,
  ): XPCalculationResult {
    // Base XP: 10 XP per minute
    const baseXP = durationMinutes * 10;

    // Bonus XP: Pronunciation score above 70 gives bonus
    const bonusXP =
      pronunciationScore > 70 ? (pronunciationScore - 70) * 0.5 : 0;

    // Streak multiplier
    let streakMultiplier = 1.0;
    if (currentStreak >= 30) {
      streakMultiplier = 1.5; // 50% bonus for 30+ day streak
    } else if (currentStreak >= 7) {
      streakMultiplier = 1.2; // 20% bonus for 7+ day streak
    }

    // Total XP
    const totalXP = Math.round((baseXP + bonusXP) * streakMultiplier);

    return {
      baseXP,
      bonusXP,
      streakMultiplier,
      totalXP,
    };
  }

  /**
   * Calculate level from total XP
   * Uses exponential curve: XP needed = level^2 * 100
   */
  calculateLevel(totalXP: number): number {
    // Level formula: level = sqrt(totalXP / 100)
    return Math.floor(Math.sqrt(totalXP / 100));
  }

  /**
   * Calculate XP needed for next level
   */
  xpForLevel(level: number): number {
    return Math.pow(level, 2) * 100;
  }

  /**
   * Check if user leveled up
   */
  checkLevelUp(
    oldXP: number,
    newXP: number,
  ): {
    leveledUp: boolean;
    oldLevel: number;
    newLevel: number;
  } {
    const oldLevel = this.calculateLevel(oldXP);
    const newLevel = this.calculateLevel(newXP);

    return {
      leveledUp: newLevel > oldLevel,
      oldLevel,
      newLevel,
    };
  }
}
