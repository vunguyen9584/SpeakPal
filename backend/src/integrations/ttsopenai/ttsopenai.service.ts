import { Injectable, Logger } from '@nestjs/common';
import { TTSOpenAIClient } from './ttsopenai.client';

export type VoiceType = 'male' | 'female' | 'neutral';

export interface TTSServiceRequest {
    text: string;
    voice?: VoiceType;
    speed?: number;
}

@Injectable()
export class TTSOpenAIService {
    private readonly logger = new Logger(TTSOpenAIService.name);
    private readonly voiceMap: Record<VoiceType, string> = {
        female: 'OA001', // Alloy (default)
        male: 'OA002',   // Echo
        neutral: 'OA003', // Fable
    };

    constructor(private readonly client: TTSOpenAIClient) { }

    /**
     * Convert text to speech (synchronous - waits for completion)
     */
    async textToSpeech(request: TTSServiceRequest): Promise<Buffer> {
        try {
            const voiceId = request.voice ? this.voiceMap[request.voice] : undefined;

            const audio = await this.client.textToSpeechSync({
                input: request.text,
                voice_id: voiceId,
                speed: request.speed,
            });

            return audio;
        } catch (error: any) {
            this.logger.error('TTS conversion failed:', error.message);
            throw error;
        }
    }

    /**
     * Convert text to speech (streaming - returns chunks as they're available)
     * Note: TTSOpenAI doesn't support true streaming, so we simulate it
     */
    async *textToSpeechStreaming(request: TTSServiceRequest): AsyncGenerator<Buffer> {
        try {
            // Get complete audio
            const audio = await this.textToSpeech(request);

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
            this.logger.error('TTS streaming failed:', error.message);
            throw error;
        }
    }

    /**
     * Get voice ID for a voice type
     */
    getVoiceId(voiceType: VoiceType): string {
        return this.voiceMap[voiceType] || this.voiceMap.female;
    }

    /**
     * Get voice ID for persona
     */
    getVoiceIdForPersona(personaVoice: string): string {
        const voiceType = personaVoice.toLowerCase() as VoiceType;
        return this.voiceMap[voiceType] || this.voiceMap.female;
    }

    /**
     * Check if service is available
     */
    isAvailable(): boolean {
        return this.client.isConfigured();
    }

    /**
     * Get available voices
     */
    getAvailableVoices() {
        return [
            { voice_id: 'OA001', name: 'Alloy', category: 'female' },
            { voice_id: 'OA002', name: 'Echo', category: 'male' },
            { voice_id: 'OA003', name: 'Fable', category: 'neutral' },
            { voice_id: 'OA004', name: 'Onyx', category: 'male' },
            { voice_id: 'OA005', name: 'Nova', category: 'female' },
            { voice_id: 'OA006', name: 'Shimmer', category: 'female' },
        ];
    }

    private delay(ms: number): Promise<void> {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}
