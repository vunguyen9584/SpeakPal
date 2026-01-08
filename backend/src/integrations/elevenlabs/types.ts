export interface ElevenLabsConfig {
  apiKey: string;
  defaultVoiceId: string;
  model: string;
  stability: number;
  similarityBoost: number;
  voiceMap: Record<string, string>;
}

export interface VoiceSettings {
  stability: number;
  similarity_boost: number;
  style?: number;
  use_speaker_boost?: boolean;
}

export interface TTSRequest {
  text: string;
  voiceId?: string;
  settings?: VoiceSettings;
}

export interface Voice {
  voice_id: string;
  name: string;
  category: string;
  labels: Record<string, string>;
}

export interface StreamingTTSOptions {
  text: string;
  voiceId: string;
  modelId?: string;
  voiceSettings?: VoiceSettings;
}
