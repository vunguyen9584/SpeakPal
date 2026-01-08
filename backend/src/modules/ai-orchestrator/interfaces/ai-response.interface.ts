export type AIResponseType =
  | 'text_result'
  | 'ai_response_start'
  | 'ai_response_audio'
  | 'ai_response_end'
  | 'correction'
  | 'suggestion';

export interface AIResponse {
  type: AIResponseType;
  data: unknown;
}

export interface TextResult {
  text: string;
  isFinal: boolean;
  confidence?: number;
  timestamp?: Date;
}

export interface AIResponseAudio {
  chunk: Buffer;
  sequence: number;
}

export interface AIResponseEnd {
  text: string;
  responseId?: string;
}

export interface Correction {
  type: 'grammar' | 'vocabulary' | 'pronunciation';
  original: string;
  corrected: string;
  explanation: string;
  explanationJa: string;
  severity: 'low' | 'medium' | 'high';
}

export interface Suggestion {
  template: string;
  vocabulary: VocabularyItem[];
  alternativeResponses: string[];
}

export interface VocabularyItem {
  word: string;
  meaning: string;
  pronunciation?: string;
  partOfSpeech?: string;
  exampleSentence?: string;
}
