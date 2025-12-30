import { SRSLevel } from '@prisma/client';

export const SRS_INTERVALS: Record<SRSLevel, number> = {
  new: 0, // Review immediately
  learning: 1, // 1 day
  young: 3, // 3 days
  mature: 7, // 7 days
  mastered: 30, // 30 days
};

export const SRS_LEVEL_ORDER: SRSLevel[] = [
  'new',
  'learning',
  'young',
  'mature',
  'mastered',
];
