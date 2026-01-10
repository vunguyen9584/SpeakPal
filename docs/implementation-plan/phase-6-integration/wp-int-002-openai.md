# WP-INT-002: OpenAI GPT-4o Integration

## Overview

| Item           | Value                                                  |
| -------------- | ------------------------------------------------------ |
| ID             | WP-INT-002                                             |
| Name           | OpenAI GPT-4o Integration                              |
| Description    | Conversation AI, error analysis, suggestion generation |
| Dependencies   | WP-BE-001 (Backend Init)                               |
| Estimated Days | 3                                                      |
| Total Tasks    | 6                                                      |
| DD References  | `05-module-design/conversation-module.md#LLMService`   |

---

## Tasks

### Task 1: Create Integration Module

- **ID**: WP-INT-002-T001
- **Type**: setup
- **Description**: Tạo OpenAI integration module
- **Files to Create**:
  - `backend/src/integrations/openai/openai.module.ts`
  - `backend/src/integrations/openai/openai.service.ts`
  - `backend/src/integrations/openai/interfaces/completion.interface.ts`
- **Acceptance Criteria**:
  - [x] Module exports OpenAIService
  - [x] API key configuration
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Configure OpenAI Client

- **ID**: WP-INT-002-T002
- **Type**: feature
- **Description**: Setup OpenAI SDK với configuration
- **Files to Create**:
  - `backend/src/integrations/openai/openai.client.ts`
- **Configuration**:

  ```typescript
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
    maxRetries: 3,
    timeout: 30000,
  });

  const defaultConfig = {
    model: "gpt-4o",
    max_tokens: 150,
    temperature: 0.7,
  };
  ```

- **Acceptance Criteria**:
  - [x] GPT-4o model configured
  - [x] Retry logic enabled
  - [x] Timeout configured (30s)
- **Estimated Hours**: 2
- **DD Reference**: `03-system-overview.md#external-services`

---

### Task 3: Implement Conversation Generation

- **ID**: WP-INT-002-T003
- **Type**: feature
- **Description**: Generate AI responses với persona-aware prompts
- **Files to Modify**:
  - `backend/src/integrations/openai/openai.service.ts`
- **Files to Create**:
  - `backend/src/integrations/openai/prompts/conversation.prompt.ts`
- **Prompt Template**:

  ```typescript
  const CONVERSATION_PROMPT = `
  You are ${persona.name}, an AI English conversation partner.
  Personality: ${persona.personality}
  Target Level: ${persona.targetLevel}
  Current Topic: ${topic}
  
  Instructions:
  1. Respond naturally to the student's message
  2. Match their language level
  3. Keep responses concise (1-3 sentences)
  4. In instructor mode, gently correct major errors
  
  Student's message: ${userMessage}
  `;
  ```

- **Acceptance Criteria**:
  - [x] Persona-aware prompts
  - [x] Level-appropriate responses
  - [x] Concise responses (1-3 sentences)
  - [x] Context management (history)
- **Estimated Hours**: 6
- **DD Reference**: `05-module-design/conversation-module.md#会話生成プロンプト`

---

### Task 4: Implement Error Analysis

- **ID**: WP-INT-002-T004
- **Type**: feature
- **Description**: Analyze user text for grammar/vocabulary errors
- **Files to Create**:
  - `backend/src/integrations/openai/prompts/error-analysis.prompt.ts`
- **Prompt Template**:

  ```typescript
  const ERROR_ANALYSIS_PROMPT = `
  Analyze the following English text for errors.
  Student Level: ${level}
  Text: "${userText}"
  
  Return JSON:
  {
    "corrections": [
      {
        "type": "grammar" | "vocabulary" | "pronunciation",
        "original": "incorrect phrase",
        "corrected": "correct phrase",
        "explanation": "brief explanation",
        "severity": "low" | "medium" | "high"
      }
    ]
  }
  
  Only include significant errors. Maximum 3 corrections.
  `;
  ```

- **Acceptance Criteria**:
  - [x] Parse JSON response reliably
  - [x] Max 3 corrections per analysis
  - [x] Level-appropriate error detection
  - [x] Include severity classification
- **Estimated Hours**: 4
- **DD Reference**: `05-module-design/conversation-module.md#エラー分析プロンプト`

---

### Task 5: Implement Streaming Response

- **ID**: WP-INT-002-T005
- **Type**: feature
- **Description**: Stream GPT responses token by token
- **Files to Modify**:
  - `backend/src/integrations/openai/openai.service.ts`
- **Implementation**:

  ```typescript
  async *streamResponse(prompt: string, history: Message[]): AsyncGenerator<string> {
    const stream = await this.openai.chat.completions.create({
      model: 'gpt-4o',
      messages: [...history, { role: 'user', content: prompt }],
      stream: true,
    });

    for await (const chunk of stream) {
      const content = chunk.choices[0]?.delta?.content;
      if (content) yield content;
    }
  }
  ```

- **Acceptance Criteria**:
  - [x] Stream response tokens
  - [x] Handle stream interruption
  - [x] Collect full response when done
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/conversation-module.md`

---

### Task 6: Add Rate Limiting & Error Handling

- **ID**: WP-INT-002-T006
- **Type**: feature
- **Description**: Handle rate limits và API errors
- **Error Handling**:
  | Error | Action |
  | -------------- | ------------------------------- |
  | Rate limited | Queue và retry after delay |
  | Timeout | Retry once với shorter prompt |
  | Invalid JSON | Return empty corrections |
  | Context too long | Truncate history |
- **Acceptance Criteria**:
  - [x] Token counting before request
  - [x] Rate limit handling
  - [x] Retry với backoff
  - [x] Context truncation if needed
- **Estimated Hours**: 2
- **DD Reference**: `11-error-handling.md`

---

## Task Summary

| Task ID         | Name                    | Type    | Hours  | Status |
| --------------- | ----------------------- | ------- | ------ | ------ |
| WP-INT-002-T001 | Create Module           | setup   | 1      | ✅     |
| WP-INT-002-T002 | Configure Client        | feature | 2      | ✅     |
| WP-INT-002-T003 | Conversation Generation | feature | 6      | ✅     |
| WP-INT-002-T004 | Error Analysis          | feature | 4      | ✅     |
| WP-INT-002-T005 | Streaming Response      | feature | 3      | ✅     |
| WP-INT-002-T006 | Rate Limit & Error      | feature | 2      | ✅     |
| **Total**       |                         |         | **18** |        |

---

_Back to: [\_phase-6.md](./_phase-6.md)_
