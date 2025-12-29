# WP-BE-010: Feedback Module (Backend)

## Overview

| Item           | Value                                                              |
| -------------- | ------------------------------------------------------------------ |
| ID             | WP-BE-010                                                          |
| Name           | Feedback Module                                                    |
| Description    | Error analysis, correction generation, vocabulary extraction       |
| Dependencies   | WP-BE-007 (Conversation Module)                                    |
| Estimated Days | 3                                                                  |
| Total Tasks    | 6                                                                  |
| DD References  | `05-module-design/feedback-module.md`, `08-api-design.md#feedback` |

---

## Tasks

### Task 1: Create Module Structure

- **ID**: WP-BE-010-T001
- **Type**: setup
- **Description**: Khởi tạo Feedback module structure
- **Commands**:
  ```bash
  cd backend
  nest g module modules/feedback
  nest g service modules/feedback
  ```
- **Files to Create**:
  - `backend/src/modules/feedback/feedback.module.ts` - Module definition
  - `backend/src/modules/feedback/feedback.service.ts` - Main service
  - `backend/src/modules/feedback/interfaces/correction.interface.ts` - Types
  - `backend/src/modules/feedback/interfaces/suggestion.interface.ts` - Types
  - `backend/src/modules/feedback/dto/correction.dto.ts` - DTOs
- **Implementation Details**:

  ```typescript
  // correction.interface.ts
  export interface Correction {
    type: "grammar" | "vocabulary" | "pronunciation";
    original: string;
    corrected: string;
    explanation: string;
    explanationJa: string;
    severity: "low" | "medium" | "high";
  }

  export interface CorrectionResult {
    corrections: Correction[];
    overallAccuracy: number;
  }
  ```

- **Acceptance Criteria**:
  - [ ] Module được tạo và export FeedbackService
  - [ ] Correction interface với type, original, corrected, explanation, severity
  - [ ] Suggestion interface với template, vocabulary, example
  - [ ] Module được import trong ConversationModule và AIOrchestratorModule
- **Estimated Hours**: 1
- **DD Reference**: `05-module-design/feedback-module.md#クラス図`

---

### Task 2: Implement Error Detection (via GPT)

- **ID**: WP-BE-010-T002
- **Type**: feature
- **Description**: Implement error detection sử dụng GPT-4o
- **Files to Modify**:
  - `backend/src/modules/feedback/feedback.service.ts`
- **Files to Create**:
  - `backend/src/modules/feedback/prompts/error-analysis.prompt.ts`
- **Implementation Details**:

  ```typescript
  // Error Analysis Prompt
  const ERROR_ANALYSIS_PROMPT = `
  Analyze the following English text for errors.
  Student Level: ${level}
  
  Text: "${userText}"
  
  Return JSON with corrections:
  {
    "corrections": [
      {
        "type": "grammar" | "vocabulary" | "pronunciation",
        "original": "incorrect phrase",
        "corrected": "correct phrase",
        "explanation": "brief explanation in English",
        "explanationJa": "brief explanation in Japanese",
        "severity": "low" | "medium" | "high"
      }
    ]
  }
  
  Rules:
  - Only include significant errors appropriate for the student's level
  - Maximum 3 corrections per message
  - For Beginner: focus on basic grammar
  - For Intermediate: include vocabulary and naturalness
  - For Advanced: include subtle nuances
  `;
  ```

- **Acceptance Criteria**:
  - [ ] Detect grammar errors (subject-verb agreement, tense, articles)
  - [ ] Detect vocabulary errors (wrong word choice)
  - [ ] Return max 3 corrections per message
  - [ ] Level-appropriate error detection
  - [ ] Both English và Japanese explanations
  - [ ] Severity classification (low/medium/high)
- **Estimated Hours**: 2.5
- **DD Reference**: `05-module-design/feedback-module.md#analyzeAndCorrect()`

---

### Task 3: Implement Correction Generation

- **ID**: WP-BE-010-T003
- **Type**: feature
- **Description**: Generate detailed corrections với explanations
- **Files to Modify**:
  - `backend/src/modules/feedback/feedback.service.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class FeedbackService {
    async analyzeAndCorrect(
      text: string,
      context: FeedbackContext
    ): Promise<CorrectionResult> {
      // 1. Call LLM with error analysis prompt
      const response = await this.llmService.analyze(
        this.buildErrorPrompt(text, context)
      );

      // 2. Parse JSON response
      const corrections = this.parseCorrections(response);

      // 3. Filter by severity based on display timing
      const filteredCorrections = this.filterBySeverity(
        corrections,
        context.displayMode // 'realtime' | 'summary' | 'detailed'
      );

      // 4. Calculate overall accuracy
      const overallAccuracy = this.calculateAccuracy(text, corrections);

      return { corrections: filteredCorrections, overallAccuracy };
    }
  }
  ```
- **Severity Display Rules**:
  | Severity | Display Timing | Description |
  | -------- | ------------------------- | ---------------------------- |
  | high | Real-time (during conv) | Errors that block meaning |
  | medium | Post-conversation summary | Grammatically wrong but clear|
  | low | Detailed analysis only | Style issues |
- **Acceptance Criteria**:
  - [ ] Parse LLM JSON response correctly
  - [ ] Filter corrections by severity và display mode
  - [ ] Calculate overall accuracy score (0-100)
  - [ ] Handle LLM parsing errors gracefully
  - [ ] Cache similar corrections để tránh duplicate calls
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/feedback-module.md#訂正タイプ`

---

### Task 4: Implement Suggestion Generation

- **ID**: WP-BE-010-T004
- **Type**: feature
- **Description**: Generate speaking suggestions với templates và vocabulary
- **Files to Modify**:
  - `backend/src/modules/feedback/feedback.service.ts`
- **Files to Create**:
  - `backend/src/modules/feedback/prompts/suggestion.prompt.ts`
- **Implementation Details**:
  ```typescript
  async generateSuggestions(
    context: SuggestionContext
  ): Promise<Suggestion> {
    // 1. Analyze conversation context
    // 2. Predict likely next utterance patterns
    // 3. Select level-appropriate vocabulary
    // 4. Generate fill-in-the-blank template

    return {
      template: "I usually [___] because [___].",
      vocabulary: [
        { word: "work from home", meaning: "在宅勤務する" },
        { word: "go to the gym", meaning: "ジムに行く" },
      ],
      alternativeResponses: [
        "I usually work from home because it's more flexible.",
        "I often go to the gym in the evening.",
      ],
    };
  }
  ```
- **Acceptance Criteria**:
  - [ ] Generate template based on conversation context
  - [ ] Include 2-5 vocabulary suggestions
  - [ ] Vocabulary includes word, meaning (Japanese)
  - [ ] Generate 2-3 alternative responses
  - [ ] Vocabulary level matches user level
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/feedback-module.md#generateSuggestions()`

---

### Task 5: Implement Vocabulary Extraction

- **ID**: WP-BE-010-T005
- **Type**: feature
- **Description**: Extract new vocabulary từ conversation để lưu vào vocabulary list
- **Files to Modify**:
  - `backend/src/modules/feedback/feedback.service.ts`
- **Files to Create**:
  - `backend/src/modules/feedback/vocabulary-extractor.service.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class VocabularyExtractorService {
    async extractVocabulary(
      turns: Turn[],
      userLevel: UserLevel
    ): Promise<VocabularyItem[]> {
      // 1. Collect all AI responses
      const aiTexts = turns
        .filter((t) => t.speaker === "ai")
        .map((t) => t.content);

      // 2. Use LLM to identify new vocabulary for user's level
      const newWords = await this.identifyNewWords(aiTexts, userLevel);

      // 3. Get detailed info for each word
      return Promise.all(newWords.map((word) => this.getWordDetails(word)));
    }

    async getWordDetails(word: string): Promise<VocabularyItem> {
      return {
        word,
        pronunciation: await this.getPronunciation(word),
        meaning: await this.getMeaning(word),
        partOfSpeech: await this.getPartOfSpeech(word),
        exampleSentence: await this.getExample(word),
      };
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] Extract vocabulary từ AI responses
  - [ ] Filter vocabulary phù hợp với user level
  - [ ] Return word, pronunciation, meaning, part of speech, example
  - [ ] Limit max 5 new words per conversation
  - [ ] Deduplicate với user's existing vocabulary
- **Estimated Hours**: 2
- **DD Reference**: `05-module-design/feedback-module.md`

---

### Task 6: Add Unit Tests

- **ID**: WP-BE-010-T006
- **Type**: test
- **Description**: Viết unit tests cho Feedback module
- **Files to Create**:
  - `backend/src/modules/feedback/tests/feedback.service.spec.ts`
  - `backend/src/modules/feedback/tests/vocabulary-extractor.spec.ts`
- **Test Cases**:
  | Test Suite | Test Cases |
  | ------------------------ | --------------------------------------------------- |
  | FeedbackService | analyzeAndCorrect - grammar, vocabulary, severity |
  | FeedbackService | generateSuggestions - template, vocabulary |
  | FeedbackService | error handling - invalid LLM response |
  | VocabularyExtractor | extractVocabulary - filter by level |
  | VocabularyExtractor | getWordDetails - complete word info |
- **Acceptance Criteria**:
  - [ ] Coverage >= 80% cho feedback service
  - [ ] Test grammar error detection
  - [ ] Test vocabulary error detection
  - [ ] Test severity filtering
  - [ ] Test suggestion generation
  - [ ] Test vocabulary extraction
  - [ ] Mock LLM calls
- **Estimated Hours**: 2.5
- **DD Reference**: N/A

---

## Task Summary

| Task ID        | Name                         | Type    | Hours  | Status |
| -------------- | ---------------------------- | ------- | ------ | ------ |
| WP-BE-010-T001 | Create Module Structure      | setup   | 1      | ⬜     |
| WP-BE-010-T002 | Implement Error Detection    | feature | 2.5    | ⬜     |
| WP-BE-010-T003 | Implement Correction Gen     | feature | 2      | ⬜     |
| WP-BE-010-T004 | Implement Suggestion Gen     | feature | 2      | ⬜     |
| WP-BE-010-T005 | Implement Vocabulary Extract | feature | 2      | ⬜     |
| WP-BE-010-T006 | Add Unit Tests               | test    | 2.5    | ⬜     |
| **Total**      |                              |         | **12** |        |

---

_Back to: [\_phase-3.md](./_phase-3.md)_
