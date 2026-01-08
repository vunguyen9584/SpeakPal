import { ApiProperty } from '@nestjs/swagger';
import { TranslationQuestion, TranslationResult } from '@prisma/client';

export class TranslationQuestionResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  topic: string;

  @ApiProperty()
  level: string;

  @ApiProperty({ description: 'Source text in Japanese' })
  sourceText: string;

  @ApiProperty()
  wordCount: number;

  @ApiProperty()
  difficulty: number;

  @ApiProperty({ description: 'Daily progress info' })
  dailyProgress: {
    completed: number;
    limit: number;
  };

  static fromEntity(
    question: TranslationQuestion,
    options: { dailyProgress: { completed: number; limit: number } },
  ): TranslationQuestionResponseDto {
    return {
      id: question.id,
      topic: question.topic,
      level: question.level,
      sourceText: question.sourceText,
      wordCount: question.wordCount,
      difficulty: question.difficulty,
      dailyProgress: options.dailyProgress,
    };
  }
}

export class TranslationResultResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ description: "User's spoken answer (transcribed)" })
  userAnswer: string;

  @ApiProperty({ description: 'Total score (0-100)' })
  totalScore: number;

  @ApiProperty({ description: 'Grammar score (0-100)' })
  grammarScore: number;

  @ApiProperty({ description: 'Vocabulary score (0-100)' })
  vocabScore: number;

  @ApiProperty({ description: 'Speed score (0-100)' })
  speedScore: number;

  @ApiProperty({ description: 'Model answer (expected translation)' })
  modelAnswer: string;

  @ApiProperty({ description: 'AI feedback' })
  feedback: {
    goodPoints: string[];
    improvements: string[];
    grammarNotes?: string;
  };

  @ApiProperty({ description: 'XP earned for this attempt' })
  xpEarned: number;

  @ApiProperty({ description: 'Whether streak bonus was applied' })
  streakBonus: boolean;

  static fromEntity(
    result: TranslationResult,
    modelAnswer: string,
    streakBonus: boolean,
  ): TranslationResultResponseDto {
    return {
      id: result.id,
      userAnswer: result.userAnswer,
      totalScore: result.totalScore,
      grammarScore: result.grammarScore || 0,
      vocabScore: result.vocabScore || 0,
      speedScore: result.speedScore || 0,
      modelAnswer,
      feedback: (result.feedback as unknown as {
        goodPoints: string[];
        improvements: string[];
        grammarNotes?: string;
      }) || {
        goodPoints: [],
        improvements: [],
      },
      xpEarned: result.xpEarned,
      streakBonus,
    };
  }
}
