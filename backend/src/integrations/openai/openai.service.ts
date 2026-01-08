import { Injectable, Logger } from '@nestjs/common';
import { OpenAIClient } from './openai.client';
import OpenAI from 'openai';
import type {
  ConversationContext,
  ErrorAnalysisRequest,
  ErrorAnalysisResult,
  StreamingResponse,
} from './types';

@Injectable()
export class OpenAIService {
  private readonly logger = new Logger(OpenAIService.name);

  constructor(private readonly openaiClient: OpenAIClient) {}

  /**
   * Generate conversation response based on persona and context
   */
  async generateConversationResponse(
    context: ConversationContext,
  ): Promise<string> {
    try {
      const systemPrompt = this.buildSystemPrompt(context);
      const messages = [
        { role: 'system' as const, content: systemPrompt },
        ...context.conversationHistory.map((msg) => ({
          role: msg.role,
          content: msg.content,
        })),
      ];

      const completion = (await this.openaiClient.createChatCompletion(
        messages,
      )) as OpenAI.Chat.ChatCompletion;

      return completion.choices[0]?.message?.content || '';
    } catch (error) {
      this.logger.error('Error generating conversation response:', error);
      throw error;
    }
  }

  /**
   * Generate streaming conversation response
   */
  async *generateStreamingConversationResponse(
    context: ConversationContext,
  ): AsyncGenerator<StreamingResponse> {
    try {
      const systemPrompt = this.buildSystemPrompt(context);
      const messages = [
        { role: 'system' as const, content: systemPrompt },
        ...context.conversationHistory.map((msg) => ({
          role: msg.role,
          content: msg.content,
        })),
      ];

      const stream = (await this.openaiClient.createStreamingChatCompletion(
        messages,
      )) as AsyncIterable<OpenAI.Chat.ChatCompletionChunk>;

      for await (const chunk of stream) {
        const content = chunk.choices[0]?.delta?.content || '';

        yield {
          content,
          done: false,
        };
      }

      yield {
        content: '',
        done: true,
      };
    } catch (error) {
      this.logger.error('Error in streaming conversation:', error);
      throw error;
    }
  }

  /**
   * Analyze user's speech for errors
   */
  async analyzeErrors(
    request: ErrorAnalysisRequest,
  ): Promise<ErrorAnalysisResult> {
    try {
      const prompt = this.buildErrorAnalysisPrompt(request);

      const completion = (await this.openaiClient.createChatCompletion([
        {
          role: 'system',
          content:
            'You are an expert English teacher analyzing student speech for errors.',
        },
        {
          role: 'user',
          content: prompt,
        },
      ])) as OpenAI.Chat.ChatCompletion;

      const responseText = completion.choices[0]?.message?.content || '{}';
      let analysis: Partial<ErrorAnalysisResult>;
      try {
        analysis = JSON.parse(responseText) as Partial<ErrorAnalysisResult>;
      } catch {
        // Fallback or retry logic could go here
        analysis = {};
      }

      return {
        errors: analysis.errors || [],
        corrections: analysis.corrections || [],
        suggestions: analysis.suggestions || [],
        vocabularyIssues: analysis.vocabularyIssues || [],
      };
    } catch (error) {
      this.logger.error('Error analyzing errors:', error);
      return {
        errors: [],
        corrections: [],
        suggestions: [],
        vocabularyIssues: [],
      };
    }
  }

  /**
   * Generate correction suggestions
   */
  async generateCorrections(
    userText: string,
    context: string,
  ): Promise<string[]> {
    try {
      const prompt = `Given the user's text: "${userText}" in the context of "${context}", provide 2-3 alternative ways to express the same idea more naturally.`;

      const completion = (await this.openaiClient.createChatCompletion([
        {
          role: 'system',
          content:
            'You are an English language expert providing alternative expressions.',
        },
        {
          role: 'user',
          content: prompt,
        },
      ])) as OpenAI.Chat.ChatCompletion;

      const responseText = completion.choices[0]?.message?.content || '';
      return responseText.split('\n').filter((line) => line.trim().length > 0);
    } catch (error) {
      this.logger.error('Error generating corrections:', error);
      return [];
    }
  }

  /**
   * Extract vocabulary from conversation
   */
  async extractVocabulary(
    conversationText: string,
    level: string,
  ): Promise<string[]> {
    try {
      const prompt = `Extract important vocabulary words from this conversation that would be useful for a ${level} level English learner:\n\n${conversationText}\n\nReturn only the words as a JSON array.`;

      const completion = (await this.openaiClient.createChatCompletion([
        {
          role: 'system',
          content: 'You are a vocabulary extraction expert.',
        },
        {
          role: 'user',
          content: prompt,
        },
      ])) as OpenAI.Chat.ChatCompletion;

      const responseText = completion.choices[0]?.message?.content || '[]';
      try {
        return JSON.parse(responseText) as string[];
      } catch {
        return [];
      }
    } catch (error) {
      this.logger.error('Error extracting vocabulary:', error);
      return [];
    }
  }

  /**
   * Build system prompt based on persona and context
   */
  private buildSystemPrompt(context: ConversationContext): string {
    return `You are an AI conversation partner helping a ${context.level} level English learner practice speaking about ${context.topic}.

Guidelines:
- Speak naturally and conversationally
- Adjust complexity to ${context.level} level
- Ask follow-up questions to encourage speaking
- Be encouraging and supportive
- Keep responses concise (2-3 sentences)
- Use vocabulary appropriate for ${context.level} level

Topic: ${context.topic}
Level: ${context.level}`;
  }

  /**
   * Build error analysis prompt
   */
  private buildErrorAnalysisPrompt(request: ErrorAnalysisRequest): string {
    return `Analyze the following English text for errors:

Text: "${request.userText}"
Context: "${request.context}"
Learner Level: ${request.level}

Please provide a JSON response with the following structure:
{
  "errors": [
    {
      "type": "grammar|vocabulary|pronunciation|fluency",
      "original": "the incorrect part",
      "correction": "the corrected version",
      "explanation": "why this is wrong and how to fix it",
      "severity": "low|medium|high"
    }
  ],
  "corrections": ["alternative way 1", "alternative way 2"],
  "suggestions": ["tip 1", "tip 2"],
  "vocabularyIssues": [
    {
      "word": "the word",
      "issue": "what's wrong",
      "suggestion": "better alternative"
    }
  ]
}`;
  }

  /**
   * Count tokens in text (approximate)
   */
  estimateTokens(text: string): number {
    // Rough estimation: ~4 characters per token
    return Math.ceil(text.length / 4);
  }
}
