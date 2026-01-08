import { SrsLevel } from '@prisma/client';

export const SRS_INTERVALS: Record<SrsLevel, number> = {
  [SrsLevel.NEW]: 0, // Review immediately
  [SrsLevel.LEARNING]: 1, // 1 day
  [SrsLevel.YOUNG]: 3, // 3 days
  [SrsLevel.MATURE]: 7, // 7 days
  [SrsLevel.MASTERED]: 30, // 30 days
};

export const SRS_LEVEL_ORDER: SrsLevel[] = [
  SrsLevel.NEW,
  SrsLevel.LEARNING,
  SrsLevel.YOUNG,
  SrsLevel.MATURE,
  SrsLevel.MASTERED,
];
