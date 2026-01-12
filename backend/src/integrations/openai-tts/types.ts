/**
 * OpenAI TTS Types
 * Based on: https://platform.openai.com/docs/api-reference/audio/createSpeech
 */

export type OpenAITTSModel = 'tts-1' | 'tts-1-hd';

export type OpenAIVoice = 'alloy' | 'echo' | 'fable' | 'onyx' | 'nova' | 'shimmer';

export type OpenAIAudioFormat = 'mp3' | 'opus' | 'aac' | 'flac' | 'wav' | 'pcm';

export interface OpenAITTSRequest {
    model: OpenAITTSModel;
    input: string;
    voice: OpenAIVoice;
    response_format?: OpenAIAudioFormat;
    speed?: number; // 0.25 to 4.0
}

export interface OpenAITTSConfig {
    apiKey: string;
    baseUrl: string;
    defaultModel: OpenAITTSModel;
    defaultVoice: OpenAIVoice;
    defaultFormat: OpenAIAudioFormat;
    defaultSpeed: number;
}
