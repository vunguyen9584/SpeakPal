export interface VocabularyItem {
  word: string;
  pronunciation: string;
  meaning: string;
  partOfSpeech: string;
  exampleSentence: string;
}

export interface Suggestion {
  template: string;
  vocabulary: VocabularyItem[];
  alternativeResponses: string[];
}
