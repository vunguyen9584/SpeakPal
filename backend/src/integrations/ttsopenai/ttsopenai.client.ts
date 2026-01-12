import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import type { TTSRequest, TTSResponse, TTSStatusResponse } from './types';

@Injectable()
export class TTSOpenAIClient {
    private readonly logger = new Logger(TTSOpenAIClient.name);
    private readonly client: AxiosInstance;
    private readonly config: {
        apiKey: string;
        baseUrl: string;
        defaultModel: string;
        defaultVoiceId: string;
        defaultSpeed: number;
    };

    constructor(private readonly configService: ConfigService) {
        this.config = {
            apiKey: this.configService.get<string>('TTSOPENAI_API_KEY') || '',
            baseUrl: this.configService.get<string>('TTSOPENAI_BASE_URL') || 'https://api.ttsopenai.com/uapi/v1',
            defaultModel: this.configService.get<string>('TTSOPENAI_MODEL') || 'tts-1',
            defaultVoiceId: this.configService.get<string>('TTSOPENAI_VOICE_ID') || 'OA001',
            defaultSpeed: parseFloat(this.configService.get<string>('TTSOPENAI_SPEED') || '1'),
        };

        this.client = axios.create({
            baseURL: this.config.baseUrl,
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': this.config.apiKey,
            },
            timeout: 30000,
        });

        this.logger.log(`TTSOpenAI client initialized with model: ${this.config.defaultModel}`);
    }

    /**
     * Convert text to speech
     * Returns a job UUID that can be used to check status and download audio
     */
    async textToSpeech(request: TTSRequest): Promise<TTSResponse> {
        try {
            const payload = {
                model: request.model || this.config.defaultModel,
                voice_id: request.voice_id || this.config.defaultVoiceId,
                speed: request.speed || this.config.defaultSpeed,
                input: request.input,
            };

            this.logger.log(`Converting text to speech: "${request.input.substring(0, 50)}..."`);

            const response = await this.client.post<TTSResponse>('/text-to-speech', payload);

            if (!response.data.success) {
                throw new Error('TTS conversion failed');
            }

            this.logger.log(`TTS job created: ${response.data.result.uuid}`);
            return response.data;
        } catch (error: any) {
            this.logger.error('Failed to convert text to speech:', error.message);
            throw error;
        }
    }

    /**
     * Check the status of a TTS job
     */
    async getStatus(uuid: string): Promise<TTSStatusResponse> {
        try {
            const response = await this.client.get<TTSStatusResponse>(`/text-to-speech/${uuid}`);
            return response.data;
        } catch (error: any) {
            this.logger.error(`Failed to get status for ${uuid}:`, error.message);
            throw error;
        }
    }

    /**
     * Wait for TTS job to complete and return audio URL
     */
    async waitForCompletion(uuid: string, maxWaitMs: number = 60000): Promise<string> {
        const startTime = Date.now();
        const pollInterval = 1000; // Poll every 1 second

        while (Date.now() - startTime < maxWaitMs) {
            const status = await this.getStatus(uuid);

            if (status.result.status === 2) {
                // Completed
                if (status.result.audio_url) {
                    this.logger.log(`TTS completed: ${uuid}`);
                    return status.result.audio_url;
                }
                throw new Error('TTS completed but no audio URL provided');
            } else if (status.result.status === 3) {
                // Error
                throw new Error(`TTS failed: ${status.result.error_message || 'Unknown error'}`);
            }

            // Still processing, wait and retry
            this.logger.debug(`TTS ${uuid} status: ${status.result.status_percentage}%`);
            await this.delay(pollInterval);
        }

        throw new Error(`TTS job ${uuid} timed out after ${maxWaitMs}ms`);
    }

    /**
     * Download audio from URL
     */
    async downloadAudio(url: string): Promise<Buffer> {
        try {
            const response = await axios.get(url, {
                responseType: 'arraybuffer',
                timeout: 30000,
            });

            return Buffer.from(response.data);
        } catch (error: any) {
            this.logger.error('Failed to download audio:', error.message);
            throw error;
        }
    }

    /**
     * Convert text to speech and wait for completion
     * Returns the audio buffer directly
     */
    async textToSpeechSync(request: TTSRequest): Promise<Buffer> {
        // Start TTS job
        const job = await this.textToSpeech(request);

        // Wait for completion
        const audioUrl = await this.waitForCompletion(job.result.uuid);

        // Download audio
        const audio = await this.downloadAudio(audioUrl);

        this.logger.log(`TTS sync completed: ${audio.length} bytes`);
        return audio;
    }

    /**
     * Get configuration
     */
    getConfig() {
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
