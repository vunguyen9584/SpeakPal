export class StreakStatsDto {
  current: number;
  longest: number;
  freezeRemaining: number;
}

export class XpStatsDto {
  total: number;
  thisWeek: number;
  level: number;
}

export class ConversationStatsDto {
  total: number;
  thisWeek: number;
  averageDuration: number;
}

export class PronunciationStatsDto {
  averageScore: number;
  trend: 'up' | 'down' | 'stable';
}

export class VocabularyStatsDto {
  total: number;
  dueForReview: number;
}

export class UserStatsDto {
  streak: StreakStatsDto;
  xp: XpStatsDto;
  conversations: ConversationStatsDto;
  pronunciation: PronunciationStatsDto;
  vocabulary: VocabularyStatsDto;
}
