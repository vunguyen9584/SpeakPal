/**
 * TTSOpenAI Client Configuration
 */

export interface TTSOpenAIConfig {
    apiKey: string;
    baseUrl: string;
    defaultModel: string;
    defaultVoiceId: string;
    defaultSpeed: number;
}

export interface TTSRequest {
    model?: string;
    voice_id?: string;
    speed?: number;
    input: string;
}

export interface TTSResponse {
    success: boolean;
    result: {
        uuid: string;
        voice_id: string;
        speed: number;
        model: string;
        tts_input: string;
        estimated_credit: number;
        used_credit: number;
        status: number; // 1: Converting, 2: Completed, 3: Error
        status_percentage: number;
        error_message: string;
        speaker_name: string;
        created_at: string;
        updated_at: string;
    };
}

export interface TTSStatusResponse {
    success: boolean;
    result: {
        uuid: string;
        status: number;
        status_percentage: number;
        audio_url?: string;
        error_message?: string;
    };
}
