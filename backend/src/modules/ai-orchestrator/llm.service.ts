import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ConversationMode } from '@prisma/client';
import { ConversationContext } from './interfaces/conversation-context.interface';
import { Correction, Suggestion } from './interfaces/ai-response.interface';

export interface LLMMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

@Injectable()
export class LLMService {
  private apiKey: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get<string>('OPENAI_API_KEY') || '';
  }

  /**
   * Generate AI response for conversation
   * @param text User input text
   * @param context Conversation context
   * @returns AI response text
   */
  generateResponse(
    text: string,
    context: ConversationContext,
  ): Promise<string> {
    try {
      const _messages = this.buildConversationPrompt(text, context);

      // TODO: Implement actual OpenAI API call
      // ... (comments kept)

      // Mock implementation
      return Promise.resolve(this.generateMockResponse(text, context));
    } catch (error) {
      console.error('LLM generateResponse error:', error);
      throw new Error('Failed to generate AI response');
    }
  }

  /**
   * Analyze user text for errors
   * @param text User input text
   * @param level User proficiency level
   * @returns Array of corrections
   */
  analyzeErrors(text: string, level: string): Promise<Correction[]> {
    try {
      const _prompt = this.buildErrorAnalysisPrompt(text, level);

      // TODO: Implement actual OpenAI API call
      // const completion = await openai.createChatCompletion({
      //   model: 'gpt-4o',
      //   messages: [{ role: 'user', content: prompt }],
      //   response_format: { type: 'json_object' },
      //   temperature: 0.3,
      // });
      //
      // const result = JSON.parse(completion.data.choices[0].message.content);
      // return result.corrections;

      // Mock implementation - return empty for now
      return Promise.resolve([] as Correction[]);
    } catch (error) {
      console.error('LLM analyzeErrors error:', error);
      return Promise.resolve([] as Correction[]);
    }
  }

  /**
   * Generate speaking suggestions
   * @param context Conversation context
   * @returns Suggestion with template and vocabulary
   */
  generateSuggestions(
    context: ConversationContext,
  ): Promise<Suggestion | null> {
    try {
      const _prompt = this.buildSuggestionPrompt(context);

      // TODO: Implement actual OpenAI API call

      // Mock implementation
      return Promise.resolve({
        template: 'I usually [___] because [___].',
        vocabulary: [
          { word: 'usually', meaning: '普段は' },
          { word: 'because', meaning: 'なぜなら' },
        ],
        alternativeResponses: [
          'I usually work from home because it is more flexible.',
          'I often go to the gym in the evening.',
        ],
      });
    } catch (error) {
      console.error('LLM generateSuggestions error:', error);
      return Promise.resolve(null);
    }
  }

  /**
   * Build conversation prompt with context
   * @private
   */
  private buildConversationPrompt(
    text: string,
    context: ConversationContext,
  ): LLMMessage[] {
    const systemPrompt = this.getSystemPrompt(context);
    const messages: LLMMessage[] = [{ role: 'system', content: systemPrompt }];

    // Add previous turns if available
    if (context.previousTurns && context.previousTurns.length > 0) {
      for (const turn of context.previousTurns.slice(-5)) {
        // Last 5 turns
        messages.push({
          role: turn.speaker === 'user' ? 'user' : 'assistant',
          content: turn.content,
        });
      }
    }

    // Add current user message
    messages.push({ role: 'user', content: text });

    return messages;
  }

  /**
   * Get system prompt based on conversation mode
   * @private
   */
  private getSystemPrompt(context: ConversationContext): string {
    const basePrompt = `You are an AI English conversation partner helping a ${context.userLevel} level student practice English.`;

    switch (context.mode) {
      case ConversationMode.INSTRUCTOR:
        return `${basePrompt} Provide helpful corrections and explanations when the student makes mistakes. Be encouraging and patient.`;
      case ConversationMode.FREETALK:
        return `${basePrompt} Have a natural, friendly conversation. Let the student lead the discussion.`;
      case ConversationMode.ROLEPLAY:
        return `${basePrompt} You are roleplaying a specific scenario. Stay in character and help the student practice realistic conversations.`;
      default:
        return basePrompt;
    }
  }

  /**
   * Build error analysis prompt
   * @private
   */
  private buildErrorAnalysisPrompt(text: string, level: string): string {
    return `
Analyze the following English text for errors.
Student Level: ${level}

Text: "${text}"

Return JSON with corrections:
{
  "corrections": [
    {
      "type": "grammar" | "vocabulary" | "pronunciation",
      "original": "incorrect phrase",
      "corrected": "correct phrase",
      "explanation": "brief explanation in English",
      "explanationJa": "brief explanation in Japanese",
      "severity": "low" | "medium" | "high"
    }
  ]
}

Rules:
- Only include significant errors appropriate for the student's level
- Maximum 3 corrections per message
- For Beginner: focus on basic grammar
- For Intermediate: include vocabulary and naturalness
- For Advanced: include subtle nuances
`.trim();
  }

  /**
   * Build suggestion generation prompt
   * @private
   */
  private buildSuggestionPrompt(context: ConversationContext): string {
    return `
Based on the conversation context, generate helpful speaking suggestions.

Topic: ${context.topic || 'General conversation'}
Level: ${context.userLevel}

Return JSON with:
{
  "template": "sentence template with [___] blanks",
  "vocabulary": [
    {"word": "word", "meaning": "Japanese meaning"}
  ],
  "alternativeResponses": ["example response 1", "example response 2"]
}
`.trim();
  }

  /**
   * Generate mock response for development
   * @private
   */
  private generateMockResponse(
    text: string,
    context: ConversationContext,
  ): string {
    const responses = [
      "That's interesting! Tell me more about that.",
      'I see. What do you think about it?',
      'How does that make you feel?',
      'Can you give me an example?',
      'That sounds fascinating!',
    ];
    return responses[Math.floor(Math.random() * responses.length)];
  }

  /**
   * Check if OpenAI service is available
   */
  healthCheck(): Promise<boolean> {
    try {
      return Promise.resolve(!!this.apiKey);
    } catch (_error) {
      return Promise.resolve(false);
    }
  }
}
