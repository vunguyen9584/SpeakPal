import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  Correction,
  CorrectionResult,
} from './interfaces/correction.interface';
import { Suggestion, VocabularyItem } from './interfaces/suggestion.interface';
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
  private correctionCache: Map<
    string,
    { corrections: Correction[]; timestamp: number }
  > = new Map();
  private readonly CACHE_TTL = 1000 * 60 * 60; // 1 hour

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
      // Check cache first
      const cacheKey = `${text}_${context.userLevel}`;
      const cached = this.correctionCache.get(cacheKey);
      if (cached && Date.now() - cached.timestamp < this.CACHE_TTL) {
        this.logger.log('Using cached corrections');
        const filteredCorrections = this.filterBySeverity(
          cached.corrections,
          context.displayMode || 'summary',
        );
        const overallAccuracy = this.calculateAccuracy(
          text,
          cached.corrections,
        );
        return { corrections: filteredCorrections, overallAccuracy };
      }

      // Build prompt
      const prompt = ERROR_ANALYSIS_PROMPT(text, context.userLevel);

      // Call OpenAI API
      const response = await this.callLLM(prompt);
      const corrections = this.parseCorrections(response);

      // Limit to max 3 corrections
      const limitedCorrections = corrections.slice(0, 3);

      // Cache the result
      this.correctionCache.set(cacheKey, {
        corrections: limitedCorrections,
        timestamp: Date.now(),
      });

      // Filter by severity based on display mode
      const filteredCorrections = this.filterBySeverity(
        limitedCorrections,
        context.displayMode || 'summary',
      );

      // Calculate overall accuracy
      const overallAccuracy = this.calculateAccuracy(text, limitedCorrections);

      return {
        corrections: filteredCorrections,
        overallAccuracy,
      };
    } catch (error) {
      this.logger.error('Error in analyzeAndCorrect:', error);
      // Fallback to empty corrections on error
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

      // Call OpenAI API
      const response = await this.callLLM(prompt);
      return this.parseSuggestion(response);
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
    if (!this.apiKey) {
      this.logger.warn(
        'OpenAI API key not configured, returning empty response',
      );
      return JSON.stringify({ corrections: [] });
    }

    try {
      const response = await fetch(
        'https://api.openai.com/v1/chat/completions',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${this.apiKey}`,
          },
          body: JSON.stringify({
            model: 'gpt-4o',
            messages: [
              {
                role: 'system',
                content:
                  'You are an expert English language teacher helping students improve their English. Always respond with valid JSON only.',
              },
              {
                role: 'user',
                content: prompt,
              },
            ],
            response_format: { type: 'json_object' },
            temperature: 0.3,
            max_tokens: 1000,
          }),
        },
      );

      if (!response.ok) {
        throw new Error(
          `OpenAI API error: ${response.status} ${response.statusText}`,
        );
      }

      const data = (await response.json()) as Record<string, any>;
      const content = data.choices?.[0]?.message?.content as string | undefined;
      return content || JSON.stringify({ corrections: [] });
    } catch (error) {
      this.logger.error('Error calling OpenAI API:', error);
      throw error;
    }
  }

  /**
   * Parse corrections from LLM response
   * @private
   */
  private parseCorrections(response: string): Correction[] {
    try {
      const parsed = JSON.parse(response) as { corrections?: Correction[] };
      return parsed.corrections || [];
    } catch (error) {
      this.logger.error('Failed to parse corrections:', error);
      return [];
    }
  }

  /**
   * Parse suggestion from LLM response
   * @private
   */
  private parseSuggestion(response: string): Suggestion | null {
    try {
      const parsed = JSON.parse(response) as Record<string, any>;
      if (
        !parsed.template ||
        !parsed.vocabulary ||
        !parsed.alternativeResponses
      ) {
        return null;
      }
      return {
        template: parsed.template as string,
        vocabulary: parsed.vocabulary as VocabularyItem[],
        alternativeResponses: parsed.alternativeResponses as string[],
      };
    } catch (error) {
      this.logger.error('Failed to parse suggestion:', error);
      return null;
    }
  }
}
