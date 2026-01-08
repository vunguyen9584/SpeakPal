import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { VocabularyItem } from './interfaces/suggestion.interface';
import { VOCABULARY_EXTRACTION_PROMPT } from './prompts/error-analysis.prompt';

export interface Turn {
  speaker: 'user' | 'ai';
  content: string;
}

@Injectable()
export class VocabularyExtractorService {
  private readonly logger = new Logger(VocabularyExtractorService.name);
  private apiKey: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get<string>('OPENAI_API_KEY') || '';
  }

  /**
   * Extract vocabulary from conversation turns
   * @param turns Conversation turns
   * @param userLevel User's English level
   * @returns List of vocabulary items (max 5)
   */
  async extractVocabulary(
    turns: Turn[],
    userLevel: string,
  ): Promise<VocabularyItem[]> {
    try {
      // 1. Collect all AI responses
      const aiTexts = turns
        .filter((t) => t.speaker === 'ai')
        .map((t) => t.content);

      if (aiTexts.length === 0) {
        return [];
      }

      // 2. Use LLM to identify new vocabulary for user's level
      const newWords = await this.identifyNewWords(aiTexts, userLevel);

      // 3. Limit to max 5 items
      return newWords.slice(0, 5);
    } catch (error) {
      this.logger.error('Error extracting vocabulary:', error);
      return [];
    }
  }

  /**
   * Identify new words using LLM
   * @private
   */
  private async identifyNewWords(
    texts: string[],
    userLevel: string,
  ): Promise<VocabularyItem[]> {
    try {
      const prompt = VOCABULARY_EXTRACTION_PROMPT(texts, userLevel);
      const response = await this.callLLM(prompt);
      return this.parseVocabulary(response);
    } catch (error) {
      this.logger.error('Error identifying new words:', error);
      return [];
    }
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
      return JSON.stringify({ vocabulary: [] });
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
                  'You are an expert English language teacher helping students learn new vocabulary. Always respond with valid JSON only.',
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

      const data = await response.json();
      return (
        data.choices[0]?.message?.content || JSON.stringify({ vocabulary: [] })
      );
    } catch (error) {
      this.logger.error('Error calling OpenAI API:', error);
      throw error;
    }
  }

  /**
   * Parse vocabulary from LLM response
   * @private
   */
  private parseVocabulary(response: string): VocabularyItem[] {
    try {
      const parsed = JSON.parse(response);
      return parsed.vocabulary || [];
    } catch (error) {
      this.logger.error('Failed to parse vocabulary:', error);
      return [];
    }
  }
}
