import { Injectable, Logger } from '@nestjs/common';
import { OpenAITTSClient } from './openai-tts.client';
import type { OpenAIVoice } from './types';

export type VoiceType = 'male' | 'female' | 'neutral';

export interface TTSServiceRequest {
    text: string;
    voice?: VoiceType;
    speed?: number;
}

@Injectable()
export class OpenAITTSService {
    private readonly logger = new Logger(OpenAITTSService.name);

    // Voice mapping: VoiceType -> OpenAI Voice
    private readonly voiceMap: Record<VoiceType, OpenAIVoice> = {
        female: 'nova',    // Nova - energetic female
        male: 'onyx',      // Onyx - deep male
        neutral: 'alloy',  // Alloy - neutral (default)
    };

    constructor(private readonly client: OpenAITTSClient) { }

    /**
     * Convert text to speech (synchronous)
     */
    async textToSpeech(request: TTSServiceRequest): Promise<Buffer> {
        try {
            const voice = request.voice ? this.voiceMap[request.voice] : 'alloy';

            const audio = await this.client.createSpeech({
                input: request.text,
                voice,
                speed: request.speed,
            });

            return audio;
        } catch (error: any) {
            this.logger.error('TTS conversion failed:', error.message);
            throw error;
        }
    }

    /**
     * Convert text to speech (streaming)
     */
    async *textToSpeechStreaming(request: TTSServiceRequest): AsyncGenerator<Buffer> {
        try {
            const voice = request.voice ? this.voiceMap[request.voice] : 'alloy';

            for await (const chunk of this.client.createSpeechStreaming({
                input: request.text,
                voice,
                speed: request.speed,
            })) {
                yield chunk;
            }
        } catch (error: any) {
            this.logger.error('TTS streaming failed:', error.message);
            throw error;
        }
    }

    /**
     * Get voice ID for a voice type
     */
    getVoiceId(voiceType: VoiceType): OpenAIVoice {
        return this.voiceMap[voiceType] || this.voiceMap.neutral;
    }

    /**
     * Get voice ID for persona
     */
    getVoiceIdForPersona(personaVoice: string): OpenAIVoice {
        const voiceType = personaVoice.toLowerCase() as VoiceType;
        return this.voiceMap[voiceType] || this.voiceMap.neutral;
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
            { voice_id: 'alloy', name: 'Alloy', category: 'neutral', description: 'Neutral voice' },
            { voice_id: 'echo', name: 'Echo', category: 'male', description: 'Male voice' },
            { voice_id: 'fable', name: 'Fable', category: 'neutral', description: 'Expressive neutral' },
            { voice_id: 'onyx', name: 'Onyx', category: 'male', description: 'Deep male voice' },
            { voice_id: 'nova', name: 'Nova', category: 'female', description: 'Energetic female' },
            { voice_id: 'shimmer', name: 'Shimmer', category: 'female', description: 'Soft female' },
        ];
    }
}
