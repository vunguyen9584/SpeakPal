import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import type { OpenAITTSRequest, OpenAITTSConfig } from './types';

@Injectable()
export class OpenAITTSClient {
    private readonly logger = new Logger(OpenAITTSClient.name);
    private readonly client: AxiosInstance;
    private readonly config: OpenAITTSConfig;

    constructor(private readonly configService: ConfigService) {
        this.config = {
            apiKey: this.configService.get<string>('OPENAI_API_KEY') || '',
            baseUrl: this.configService.get<string>('OPENAI_BASE_URL') || 'https://api.openai.com/v1',
            defaultModel: (this.configService.get<string>('OPENAI_TTS_MODEL') || 'tts-1') as any,
            defaultVoice: (this.configService.get<string>('OPENAI_TTS_VOICE') || 'alloy') as any,
            defaultFormat: (this.configService.get<string>('OPENAI_TTS_FORMAT') || 'mp3') as any,
            defaultSpeed: parseFloat(this.configService.get<string>('OPENAI_TTS_SPEED') || '1'),
        };

        this.client = axios.create({
            baseURL: this.config.baseUrl,
            headers: {
                'Authorization': `Bearer ${this.config.apiKey}`,
                'Content-Type': 'application/json',
            },
            timeout: 60000, // 60s for audio generation
        });

        this.logger.log(`OpenAI TTS client initialized with model: ${this.config.defaultModel}`);
    }

    /**
     * Create speech from text
     * Returns audio buffer directly (streaming response)
     */
    async createSpeech(request: Partial<OpenAITTSRequest>): Promise<Buffer> {
        try {
            const payload: OpenAITTSRequest = {
                model: request.model || this.config.defaultModel,
                input: request.input || '',
                voice: request.voice || this.config.defaultVoice,
                response_format: request.response_format || this.config.defaultFormat,
                speed: request.speed || this.config.defaultSpeed,
            };

            this.logger.log(`Creating speech: "${payload.input.substring(0, 50)}..." (voice: ${payload.voice})`);

            const response = await this.client.post('/audio/speech', payload, {
                responseType: 'arraybuffer',
            });

            const audio = Buffer.from(response.data);
            this.logger.log(`Speech created: ${audio.length} bytes`);

            return audio;
        } catch (error: any) {
            this.logger.error('Failed to create speech:', error.message);
            if (error.response) {
                this.logger.error('Response status:', error.response.status);
                this.logger.error('Response data:', error.response.data?.toString());
            }
            throw error;
        }
    }

    /**
     * Create speech with streaming (simulated by chunking the response)
     */
    async *createSpeechStreaming(request: Partial<OpenAITTSRequest>): AsyncGenerator<Buffer> {
        try {
            // Get complete audio
            const audio = await this.createSpeech(request);

            // Split into chunks for streaming effect
            const chunkSize = 4096; // 4KB chunks
            const totalChunks = Math.ceil(audio.length / chunkSize);

            for (let i = 0; i < totalChunks; i++) {
                const start = i * chunkSize;
                const end = Math.min(start + chunkSize, audio.length);
                const chunk = audio.slice(start, end);

                yield chunk;

                // Small delay to simulate streaming
                if (i < totalChunks - 1) {
                    await this.delay(50);
                }
            }
        } catch (error: any) {
            this.logger.error('Failed to stream speech:', error.message);
            throw error;
        }
    }

    /**
     * Get configuration
     */
    getConfig(): OpenAITTSConfig {
        return { ...this.config };
    }

    /**
     * Check if service is configured
     */
    isConfigured(): boolean {
        return !!this.config.apiKey;
    }

    private delay(ms: number): Promise<void> {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}
