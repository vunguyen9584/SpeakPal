# WP-DB-001: Translation Tables Migration

> 📦 Work Package: Translation Database Migration
> 📅 Estimated: 1 day (8 hours)
> 🔗 Dependencies: WP-BE-002 (Database Schema)
> 📚 DD Reference: `07-database-design/translation-tables.md`

---

## 📊 Overview

| Metric     | Value                                                                                                        |
| ---------- | ------------------------------------------------------------------------------------------------------------ |
| Tasks      | 4                                                                                                            |
| Est. Hours | 8                                                                                                            |
| Tables     | 5 (translation_questions, translation_results, intent_questions, shadowing_contents, quick_response_results) |
| Indexes    | 8                                                                                                            |
| Enums      | 2 (PracticeType, ContentType)                                                                                |

---

## 📋 Task List

| Task ID | Task Name                          | Type    | Hours | Status |
| ------- | ---------------------------------- | ------- | ----- | ------ |
| P5-T001 | Create Translation Enums           | feature | 1     | ⬜     |
| P5-T002 | Create Translation Questions Table | feature | 2     | ⬜     |
| P5-T003 | Create Translation Results Tables  | feature | 3     | ⬜     |
| P5-T004 | Create Migration & Seed Data       | feature | 2     | ⬜     |

---

## 🎯 Task Details

### P5-T001: Create Translation Enums

**Type:** feature
**Est. Hours:** 1
**DD Ref:** `07-database-design/translation-tables.md#enums`

---

#### Description

Tạo các enum types cho Translation Practice module. Bao gồm PracticeType (direct, intent, word_assoc, instant_drill, shadowing) và ContentType cho shadowing contents.

#### Files

| Action | Path                   |
| ------ | ---------------------- |
| Modify | `prisma/schema.prisma` |

#### Prisma Schema

```prisma
enum PracticeType {
  DIRECT
  INTENT
  WORD_ASSOCIATION
  INSTANT_DRILL
  SHADOWING
}

enum ContentType {
  CONVERSATION
  NEWS
  SPEECH
  PODCAST
}
```

#### Acceptance Criteria

- [ ] PracticeType enum với 5 values được định nghĩa trong Prisma schema
- [ ] ContentType enum với 4 values được định nghĩa
- [ ] Schema validates thành công (`npx prisma validate`)
- [ ] Enums có documentation comments

---

### P5-T002: Create Translation Questions Table

**Type:** feature
**Est. Hours:** 2
**DD Ref:** `07-database-design/translation-tables.md#translation_questions`

---

#### Description

Tạo table `translation_questions` để lưu trữ câu hỏi dịch thuật với source text (母国語), target text (English), alternative answers, difficulty level và grammar points.

#### Files

| Action | Path                                                          |
| ------ | ------------------------------------------------------------- |
| Modify | `prisma/schema.prisma`                                        |
| Create | `prisma/migrations/YYYYMMDD_create_translation_questions.sql` |

#### Prisma Schema

```prisma
model TranslationQuestion {
  id              String   @id @default(uuid())
  topic           String   @db.VarChar(50)       // daily, business, travel, news, entertainment
  level           UserLevel
  sourceLanguage  String   @default("ja") @db.VarChar(5)
  sourceText      String   @db.Text              // 母国語の問題文
  targetText      String   @db.Text              // 模範解答（英語）
  altAnswers      Json?                          // 代替正解リスト
  difficulty      Int      @default(3)           // 1-5
  wordCount       Int
  grammarPoints   Json?                          // ["present_simple", "articles"]
  isActive        Boolean  @default(true)
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt

  // Relations
  results         TranslationResult[]

  @@index([topic, level, isActive])
  @@index([level, difficulty])
  @@map("translation_questions")
}
```

#### Acceptance Criteria

- [ ] Table translation_questions created với tất cả columns theo DD
- [ ] Indexes cho (topic, level, isActive) và (level, difficulty) được tạo
- [ ] Foreign key constraint không có (standalone table)
- [ ] Migration chạy thành công
- [ ] Sample data verification query chạy được

---

### P5-T003: Create Translation Results Tables

**Type:** feature
**Est. Hours:** 3
**DD Ref:** `07-database-design/translation-tables.md#results_tables`

---

#### Description

Tạo các tables để lưu kết quả luyện tập: `translation_results`, `intent_questions`, `shadowing_contents`, và `quick_response_results`. Các tables này track user progress, scores, và XP earned.

#### Files

| Action | Path                                                        |
| ------ | ----------------------------------------------------------- |
| Modify | `prisma/schema.prisma`                                      |
| Create | `prisma/migrations/YYYYMMDD_create_translation_results.sql` |

#### Prisma Schema

```prisma
model TranslationResult {
  id              String       @id @default(uuid())
  userId          String
  practiceType    PracticeType
  questionId      String?
  userAnswer      String       @db.Text
  totalScore      Int          // 0-100
  grammarScore    Int?
  vocabScore      Int?
  speedScore      Int?
  intentScore     Int?
  responseTimeSec Float?
  feedback        Json?
  xpEarned        Int          @default(0)
  createdAt       DateTime     @default(now())

  // Relations
  user            User         @relation(fields: [userId], references: [id])
  question        TranslationQuestion? @relation(fields: [questionId], references: [id])

  @@index([userId, practiceType, createdAt])
  @@index([userId, createdAt])
  @@map("translation_results")
}

model IntentQuestion {
  id                  String    @id @default(uuid())
  category            String    @db.VarChar(50)  // greeting, daily, business, emotion, request
  level               UserLevel
  intentDescription   String    @db.Text         // シチュエーション説明
  expectedExpressions Json                       // ["Can I...", "Would you..."]
  alternativePhrases  Json                       // 代替表現
  difficulty          Int       @default(3)
  isActive            Boolean   @default(true)
  createdAt           DateTime  @default(now())

  @@index([category, level, isActive])
  @@map("intent_questions")
}

model ShadowingContent {
  id              String      @id @default(uuid())
  contentType     ContentType
  title           String      @db.VarChar(200)
  description     String?     @db.Text
  level           UserLevel
  transcript      String      @db.Text
  audioUrl        String      @db.VarChar(500)
  timestamps      Json                          // [{startTime, endTime, text}]
  durationSec     Int
  isPremium       Boolean     @default(false)
  thumbnailUrl    String?     @db.VarChar(500)
  isActive        Boolean     @default(true)
  createdAt       DateTime    @default(now())

  @@index([contentType, level, isActive])
  @@index([isPremium, isActive])
  @@map("shadowing_contents")
}

model QuickResponseResult {
  id              String       @id @default(uuid())
  userId          String
  practiceType    PracticeType // WORD_ASSOCIATION, INSTANT_DRILL, SHADOWING
  sessionId       String?
  contentId       String?
  totalScore      Int
  correctCount    Int?
  maxChain        Int?
  followingScore  Int?
  pronunciationScore Int?
  rhythmScore     Int?
  durationSec     Int?
  details         Json?
  xpEarned        Int          @default(0)
  createdAt       DateTime     @default(now())

  // Relations
  user            User         @relation(fields: [userId], references: [id])

  @@index([userId, practiceType, createdAt])
  @@map("quick_response_results")
}
```

#### Acceptance Criteria

- [ ] 4 tables created với tất cả columns và relations
- [ ] Foreign keys to User table được define
- [ ] Indexes cho query patterns thường dùng
- [ ] Migration chạy thành công không có errors
- [ ] Prisma generate types thành công

---

### P5-T004: Create Migration & Seed Data

**Type:** feature
**Est. Hours:** 2
**DD Ref:** `07-database-design/translation-tables.md#seed`

---

#### Description

Tạo migration file, chạy migration, và seed sample data cho testing. Bao gồm translation questions cho các topics và levels khác nhau, intent questions, và shadowing content samples.

#### Files

| Action | Path                              |
| ------ | --------------------------------- |
| Create | `prisma/seed/translation-seed.ts` |
| Modify | `prisma/seed/index.ts`            |

#### Seed Data Requirements

```typescript
// Sample translation questions
const translationQuestions = [
  {
    topic: "daily",
    level: "Beginner",
    sourceText: "今日の天気はいいですね。",
    targetText: "The weather is nice today.",
    altAnswers: ["Today's weather is nice.", "It's nice weather today."],
    difficulty: 1,
    wordCount: 5,
    grammarPoints: ["present_simple", "adjectives"],
  },
  // ... 20+ more samples per topic/level
];

// Sample intent questions
const intentQuestions = [
  {
    category: "business",
    level: "Intermediate",
    intentDescription:
      "You want to politely decline a meeting invitation because you have a prior commitment.",
    expectedExpressions: [
      "I'm afraid I can't make it.",
      "Unfortunately, I have a prior commitment.",
    ],
    alternativePhrases: [
      "I'm sorry, but I won't be able to attend.",
      "I regret that I have another engagement.",
    ],
  },
];

// Sample shadowing contents
const shadowingContents = [
  {
    contentType: "CONVERSATION",
    title: "At the Coffee Shop",
    level: "Beginner",
    transcript: "Hi, can I have a coffee please?...",
    audioUrl: "https://cdn.example.com/shadowing/coffee-shop.mp3",
    durationSec: 45,
    isPremium: false,
  },
];
```

#### Acceptance Criteria

- [ ] Migration runs successfully: `npx prisma migrate dev`
- [ ] Seed data includes 50+ translation questions across topics
- [ ] Seed data includes 20+ intent questions
- [ ] Seed data includes 10+ shadowing contents
- [ ] `npx prisma db seed` completes without errors
- [ ] All tables can be queried via Prisma Client

---

## 📊 Phase Progress

| Task ID | Task Name                          | Status     | Completed |
| ------- | ---------------------------------- | ---------- | --------- |
| P5-T001 | Create Translation Enums           | ⬜ Pending | -         |
| P5-T002 | Create Translation Questions Table | ⬜ Pending | -         |
| P5-T003 | Create Translation Results Tables  | ⬜ Pending | -         |
| P5-T004 | Create Migration & Seed Data       | ⬜ Pending | -         |

**Progress: 0/4 (0%)**

---

_Created: 2026-01-07_
