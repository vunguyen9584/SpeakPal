/**
 * Server to Client Events
 */
export interface ServerEvents {
  // Connection
  connected: (data: ConnectedData) => void;

  // Transcription results
  text_result: (data: TextResultData) => void;

  // AI response
  ai_response_start: (data: AIResponseStartData) => void;
  ai_response_audio: (data: AIResponseAudioData) => void;
  ai_response_end: (data: AIResponseEndData) => void;

  // Feedback
  correction: (data: CorrectionData) => void;
  suggestion: (data: SuggestionData) => void;

  // Errors
  error: (data: ErrorData) => void;
  rate_limited: (data: RateLimitData) => void;
}

export interface ConnectedData {
  sessionId: string;
  serverTime: string;
}

export interface TextResultData {
  text: string;
  isFinal: boolean;
  confidence?: number;
  timestamp: string;
}

export interface AIResponseStartData {
  responseId: string;
}

export interface AIResponseAudioData {
  chunk: string; // Base64 encoded audio
  sequence: number;
}

export interface AIResponseEndData {
  responseId: string;
  text: string;
}

export interface CorrectionData {
  corrections: Array<{
    type: string;
    original: string;
    corrected: string;
    explanation: string;
    severity: string;
  }>;
}

export interface SuggestionData {
  template: string;
  vocabulary: Array<{
    word: string;
    meaning: string;
  }>;
  alternativeResponses: string[];
}

export interface ErrorData {
  code: string;
  message: string;
  recoverable: boolean;
  action?: string;
}

export interface RateLimitData {
  message: string;
  retryAfter?: number;
}
