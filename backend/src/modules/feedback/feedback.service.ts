import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  Correction,
  CorrectionResult,
} from './interfaces/correction.interface';
import {
  Suggestion,
  VocabularyItem,
} from './interfaces/suggestion.interface';
import {
  ERROR_ANALYSIS_PROMPT,
  SUGGESTION_PROMPT,
  VOCABULARY_EXTRACTION_PROMPT,
} from './prompts/error-analysis.prompt';

export interface FeedbackContext {
  userLevel: string;
  displayMode?: 'realtime' | 'summary' | 'detailed';
}

export interface SuggestionContext {
  conversationContext: string;
  userLevel: string;
  topic?: string;
}

@Injectable()
export class FeedbackService {
  private readonly logger = new Logger(FeedbackService.name);
  private apiKey: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get<string>('OPENAI_API_KEY') || '';
  }

  /**
   * Analyze user text and generate corrections
   * @param text User input text
   * @param context Feedback context
   * @returns Correction result with accuracy score
   */
  async analyzeAndCorrect(
    text: string,
    context: FeedbackContext,
  ): Promise<CorrectionResult> {
    try {
      // Build prompt
      const prompt = ERROR_ANALYSIS_PROMPT(text, context.userLevel);

      // TODO: Call OpenAI API
      // const response = await this.callLLM(prompt);
      // const corrections = this.parseCorrections(response);

      // Mock implementation
      const corrections = this.getMockCorrections(text);

      // Filter by severity based on display mode
      const filteredCorrections = this.filterBySeverity(
        corrections,
        context.displayMode || 'summary',
      );

      // Calculate overall accuracy
      const overallAccuracy = this.calculateAccuracy(text, corrections);

      return {
        corrections: filteredCorrections,
        overallAccuracy,
      };
    } catch (error) {
      this.logger.error('Error in analyzeAndCorrect:', error);
      return {
        corrections: [],
        overallAccuracy: 100,
      };
    }
  }

  /**
   * Generate speaking suggestions
   * @param context Suggestion context
   * @returns Suggestion with template and vocabulary
   */
  async generateSuggestions(
    context: SuggestionContext,
  ): Promise<Suggestion | null> {
    try {
      const prompt = SUGGESTION_PROMPT(
        context.conversationContext,
        context.userLevel,
        context.topic,
      );

      // TODO: Call OpenAI API
      // const response = await this.callLLM(prompt);
      // return this.parseSuggestion(response);

      // Mock implementation
      return {
        template: 'I usually [___] because [___].',
        vocabulary: [
          {
            word: 'usually',
            pronunciation: '/ˈjuːʒuəli/',
            meaning: '普段は、たいてい',
            partOfSpeech: 'adverb',
            exampleSentence: 'I usually wake up at 7 AM.',
          },
          {
            word: 'because',
            pronunciation: '/bɪˈkɔːz/',
            meaning: 'なぜなら',
            partOfSpeech: 'conjunction',
            exampleSentence: 'I stayed home because it was raining.',
          },
        ],
        alternativeResponses: [
          'I usually work from home because it is more flexible.',
          'I often go to the gym in the evening.',
        ],
      };
    } catch (error) {
      this.logger.error('Error in generateSuggestions:', error);
      return null;
    }
  }

  /**
   * Filter corrections by severity and display mode
   * @private
   */
  private filterBySeverity(
    corrections: Correction[],
    displayMode: 'realtime' | 'summary' | 'detailed',
  ): Correction[] {
    switch (displayMode) {
      case 'realtime':
        // Only high severity errors in real-time
        return corrections.filter((c) => c.severity === 'high');
      case 'summary':
        // High and medium severity in summary
        return corrections.filter((c) =>
          ['high', 'medium'].includes(c.severity),
        );
      case 'detailed':
        // All corrections in detailed view
        return corrections;
      default:
        return corrections;
    }
  }

  /**
   * Calculate overall accuracy score
   * @private
   */
  private calculateAccuracy(text: string, corrections: Correction[]): number {
    if (corrections.length === 0) {
      return 100;
    }

    // Simple formula: reduce score based on number and severity of corrections
    const severityWeights = { high: 15, medium: 10, low: 5 };
    const totalDeduction = corrections.reduce((sum, c) => {
      return sum + (severityWeights[c.severity] || 5);
    }, 0);

    return Math.max(0, 100 - totalDeduction);
  }

  /**
   * Get mock corrections for development
   * @private
   */
  private getMockCorrections(text: string): Correction[] {
    // Return empty for now - can be enhanced for testing
    return [];
  }

  /**
   * Call OpenAI LLM
   * @private
   */
  private async callLLM(prompt: string): Promise<string> {
    // TODO: Implement actual OpenAI API call
    throw new Error('Not implemented');
  }

  /**
   * Parse corrections from LLM response
   * @private
   */
  private parseCorrections(response: string): Correction[] {
    try {
      const parsed = JSON.parse(response);
      return parsed.corrections || [];
    } catch (error) {
      this.logger.error('Failed to parse corrections:', error);
      return [];
    }
  }
}

