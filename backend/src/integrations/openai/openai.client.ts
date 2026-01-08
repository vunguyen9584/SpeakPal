import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import type { OpenAIConfig } from './types';

@Injectable()
export class OpenAIClient {
    private readonly logger = new Logger(OpenAIClient.name);
    private readonly client: OpenAI;
    private readonly config: OpenAIConfig;

    constructor(private readonly configService: ConfigService) {
        const apiKey = this.configService.get<string>('OPENAI_API_KEY');

        if (!apiKey) {
            this.logger.warn('OPENAI_API_KEY not configured');
        }

        this.client = new OpenAI({
            apiKey: apiKey || '',
        });

        this.config = {
            apiKey: apiKey || '',
            model: this.configService.get<string>('OPENAI_MODEL', 'gpt-4o'),
            temperature: this.configService.get<number>('OPENAI_TEMPERATURE', 0.7),
            maxTokens: this.configService.get<number>('OPENAI_MAX_TOKENS', 2000),
        };

        this.logger.log(`OpenAI client initialized with model: ${this.config.model}`);
    }

    getClient(): OpenAI {
        return this.client;
    }

    getConfig(): OpenAIConfig {
        return { ...this.config };
    }

    /**
     * Create chat completion
     */
    async createChatCompletion(
        messages: OpenAI.Chat.ChatCompletionMessageParam[],
        options?: Partial<OpenAI.Chat.ChatCompletionCreateParams>,
    ) {
        return this.client.chat.completions.create({
            model: this.config.model,
            messages,
            temperature: this.config.temperature,
            max_tokens: this.config.maxTokens,
            ...options,
        });
    }

    /**
     * Create streaming chat completion
     */
    async createStreamingChatCompletion(
        messages: OpenAI.Chat.ChatCompletionMessageParam[],
        options?: Partial<OpenAI.Chat.ChatCompletionCreateParams>,
    ) {
        return this.client.chat.completions.create({
            model: this.config.model,
            messages,
            temperature: this.config.temperature,
            max_tokens: this.config.maxTokens,
            stream: true,
            ...options,
        });
    }
}
