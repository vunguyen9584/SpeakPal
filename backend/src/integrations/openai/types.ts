export interface OpenAIConfig {
  apiKey: string;
  model: string;
  temperature: number;
  maxTokens: number;
}

export interface ConversationContext {
  personaId: string;
  topic: string;
  level: string;
  conversationHistory: Message[];
}

export interface Message {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface ErrorAnalysisRequest {
  userText: string;
  context: string;
  level: string;
}

export interface ErrorAnalysisResult {
  errors: DetectedError[];
  corrections: string[];
  suggestions: string[];
  vocabularyIssues: VocabularyIssue[];
}

export interface DetectedError {
  type: 'grammar' | 'vocabulary' | 'pronunciation' | 'fluency';
  original: string;
  correction: string;
  explanation: string;
  severity: 'low' | 'medium' | 'high';
}

export interface VocabularyIssue {
  word: string;
  issue: string;
  suggestion: string;
}

export interface StreamingResponse {
  content: string;
  done: boolean;
  tokens?: number;
}
