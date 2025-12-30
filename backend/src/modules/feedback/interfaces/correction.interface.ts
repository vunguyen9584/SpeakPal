export interface Correction {
  type: 'grammar' | 'vocabulary' | 'pronunciation';
  original: string;
  corrected: string;
  explanation: string;
  explanationJa: string;
  severity: 'low' | 'medium' | 'high';
}

export interface CorrectionResult {
  corrections: Correction[];
  overallAccuracy: number;
}
