export interface DeepgramConfig {
  apiKey: string;
  model: string;
  language: string;
  punctuate: boolean;
  interimResults: boolean;
}

export interface TranscriptionResult {
  transcript: string;
  confidence: number;
  isFinal: boolean;
  words?: WordInfo[];
}

export interface WordInfo {
  word: string;
  start: number;
  end: number;
  confidence: number;
}

export interface StreamingOptions {
  encoding: string;
  sampleRate: number;
  channels: number;
}
