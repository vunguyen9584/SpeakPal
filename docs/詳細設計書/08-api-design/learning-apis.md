# 8.6. Learning APIs

## API-301: GET /vocabularies

### Query Parameters

| Parameter | Type   | Required | Description         |
| --------- | ------ | -------- | ------------------- |
| page      | number | No       | Default: 1          |
| limit     | number | No       | Max: 100            |
| srsLevel  | string | No       | Filter by SRS level |

### Response

```typescript
interface VocabularyListResponse {
  data: Vocabulary[];
  pagination: Pagination;
}

interface Vocabulary {
  id: string;
  word: string;
  meaning: string;
  pronunciation: string;
  exampleSentence: string;
  srsLevel: "new" | "learning" | "young" | "mature" | "mastered";
  nextReviewDate: string;
  reviewCount: number;
  correctCount: number;
  createdAt: string;
}
```

---

## API-302: POST /vocabularies

### Request

```typescript
interface CreateVocabularyRequest {
  word: string; // 1-100 chars
  meaning: string; // 1-500 chars
  pronunciation?: string; // Optional
  exampleSentence?: string; // Optional
  conversationId?: string; // Link to conversation
}
```

### Response (201 Created)

```typescript
interface VocabularyResponse {
  id: string;
  word: string;
  meaning: string;
  pronunciation: string;
  exampleSentence: string;
  srsLevel: "new";
  nextReviewDate: string;
  createdAt: string;
}
```

---

## API-303: GET /vocabularies/due

### Response

```typescript
interface DueVocabularyResponse {
  data: Vocabulary[];
  totalDue: number;
}
```

---

## API-304: POST /vocabularies/:id/review

### Request

```typescript
interface ReviewRequest {
  result: "correct" | "incorrect";
}
```

### Response

```typescript
interface ReviewResponse {
  id: string;
  previousLevel: string;
  newLevel: string;
  nextReviewDate: string;
  xpEarned: number;
}
```

---

## API-305: GET /scenarios

### Query Parameters

| Parameter  | Type   | Required | Description        |
| ---------- | ------ | -------- | ------------------ |
| category   | string | No       | Filter by category |
| difficulty | string | No       | Filter by level    |

### Response

```typescript
interface ScenarioListResponse {
  data: Scenario[];
}

interface Scenario {
  id: string;
  title: string;
  titleJa: string;
  description: string;
  category: "daily" | "business" | "travel" | "academic" | "test_prep";
  difficulty: "beginner" | "intermediate" | "advanced";
  estimatedDuration: number;
}
```

---

## API-306: GET /challenges/today

### Response

```typescript
interface TodayChallengesResponse {
  data: UserChallenge[];
}

interface UserChallenge {
  id: string;
  challenge: {
    id: string;
    type: string;
    title: string;
    titleJa: string;
    description: string;
    xpReward: number;
  };
  currentProgress: number;
  targetProgress: number;
  status: "active" | "completed";
  completedAt: string | null;
}
```

---

← [Conversation APIs](./conversation-apis.md) | _次: [Gamification APIs](./gamification-apis.md)_
