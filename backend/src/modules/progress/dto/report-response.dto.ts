import { ApiProperty } from '@nestjs/swagger';

export class ReportSummaryDto {
  @ApiProperty()
  totalConversations: number;

  @ApiProperty()
  totalMinutes: number;

  @ApiProperty()
  totalXp: number;

  @ApiProperty()
  totalVocabularyReviews: number;
}

export class PronunciationTrendDto {
  @ApiProperty()
  date: string;

  @ApiProperty()
  averageScore: number;
}

export class TopCorrectionDto {
  @ApiProperty()
  type: string;

  @ApiProperty()
  count: number;

  @ApiProperty()
  examples: string[];
}

export class VocabularyProgressDto {
  @ApiProperty()
  newWords: number;

  @ApiProperty()
  reviewedWords: number;

  @ApiProperty()
  masteredWords: number;
}

export class AchievementDto {
  @ApiProperty()
  type: 'badge' | 'level_up' | 'streak_milestone';

  @ApiProperty()
  title: string;

  @ApiProperty()
  description: string;

  @ApiProperty()
  earnedAt: Date;

  @ApiProperty({ required: false })
  iconUrl?: string;
}

export class WeeklyReportResponseDto {
  @ApiProperty()
  weekNumber: number;

  @ApiProperty()
  year: number;

  @ApiProperty()
  startDate: Date;

  @ApiProperty()
  endDate: Date;

  @ApiProperty({ type: ReportSummaryDto })
  summary: ReportSummaryDto;

  @ApiProperty({ type: [PronunciationTrendDto] })
  pronunciationTrend: PronunciationTrendDto[];

  @ApiProperty({ type: [TopCorrectionDto] })
  topCorrections: TopCorrectionDto[];

  @ApiProperty({ type: VocabularyProgressDto })
  vocabularyProgress: VocabularyProgressDto;

  @ApiProperty({ type: [AchievementDto] })
  achievements: AchievementDto[];
}

export class MonthlyReportResponseDto {
  @ApiProperty()
  month: number;

  @ApiProperty()
  year: number;

  @ApiProperty()
  startDate: Date;

  @ApiProperty()
  endDate: Date;

  @ApiProperty({ type: ReportSummaryDto })
  summary: ReportSummaryDto;

  @ApiProperty({ type: [PronunciationTrendDto] })
  pronunciationTrend: PronunciationTrendDto[];

  @ApiProperty({ type: [TopCorrectionDto] })
  topCorrections: TopCorrectionDto[];

  @ApiProperty({ type: VocabularyProgressDto })
  vocabularyProgress: VocabularyProgressDto;

  @ApiProperty({ type: [AchievementDto] })
  achievements: AchievementDto[];
}
