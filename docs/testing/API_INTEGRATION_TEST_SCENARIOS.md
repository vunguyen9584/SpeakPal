# API Integration Test Scenarios

> Version: 1.0  
> Created: 2026-01-08  
> Purpose: Verify API integration works correctly for frontend consumption

---

## 📋 Mục Lục

1. [Tổng Quan](#1-tổng-quan)
2. [Môi Trường Test](#2-môi-trường-test)
3. [Test Scenarios](#3-test-scenarios)
   - [3.1 Auth Flow](#31-auth-flow)
   - [3.2 User Profile Flow](#32-user-profile-flow)
   - [3.3 Persona Management Flow](#33-persona-management-flow)
   - [3.4 Conversation Flow](#34-conversation-flow)
   - [3.5 Learning Flow](#35-learning-flow)
   - [3.6 Gamification Flow](#36-gamification-flow)
   - [3.7 Social Flow](#37-social-flow)
   - [3.8 Subscription Flow](#38-subscription-flow)
   - [3.9 Translation Flow](#39-translation-flow)
   - [3.10 WebSocket Flow](#310-websocket-flow)
4. [Cross-API Integration Tests](#4-cross-api-integration-tests)
5. [Error Handling Tests](#5-error-handling-tests)
6. [Performance Tests](#6-performance-tests)

---

## 1. Tổng Quan

### 1.1 Phạm Vi

Tài liệu này định nghĩa các kịch bản test để kiểm tra sự phối hợp giữa các Backend API. Mỗi kịch bản mô phỏng cách Frontend sẽ gọi các API một cách tuần tự và đảm bảo data flow hoạt động đúng.

### 1.2 Các Loại Test

| Loại Test       | Mô Tả                               |
| --------------- | ----------------------------------- |
| **Smoke Test**  | Kiểm tra cơ bản, API hoạt động      |
| **Integration** | Kiểm tra phối hợp nhiều API         |
| **Flow Test**   | Kiểm tra luồng nghiệp vụ hoàn chỉnh |
| **Edge Case**   | Kiểm tra các trường hợp biên        |
| **Error Test**  | Kiểm tra xử lý lỗi                  |

### 1.3 Ký Hiệu

- ✅ Pass
- ❌ Fail
- ⏳ Pending
- 🔄 Retry

---

## 2. Môi Trường Test

### 2.1 Environment Variables

```env
BASE_URL=http://localhost:3000/api/v1
WS_URL=ws://localhost:3000/ws
DATABASE_URL=postgresql://test:test@localhost:5432/speakpal_test
```

### 2.2 Test User Seeds

| User      | Email             | Password | Level        | Plan    |
| --------- | ----------------- | -------- | ------------ | ------- |
| testUser1 | test1@example.com | Test@123 | Beginner     | Free    |
| testUser2 | test2@example.com | Test@123 | Intermediate | Premium |
| testUser3 | test3@example.com | Test@123 | Advanced     | Free    |

### 2.3 Preconditions

1. Database được seed với data test
2. External services được mock (OpenAI, STT, TTS)
3. Redis cache được clear trước mỗi test suite

### 2.4 Cách run test

```bash
npm run test:e2e -- --integration.e2e-spec.ts
```

---

## 3. Test Scenarios

### 3.1 Auth Flow

#### TST-AUTH-001: User Registration Flow

**Objective**: Kiểm tra luồng đăng ký người dùng mới hoàn chỉnh

**Preconditions**: Email chưa tồn tại trong hệ thống

**Steps**:

| Step | Action                               | Expected Result                     | API                   |
| ---- | ------------------------------------ | ----------------------------------- | --------------------- |
| 1    | POST /auth/register với valid data   | 201 Created, accessToken, user info | /auth/register        |
| 2    | Verify accessToken có thể dùng được  | 200 OK, user data                   | GET /users/me         |
| 3    | Verify default subscription được tạo | plan: "free"                        | GET /subscriptions/me |
| 4    | Verify streak record được tạo        | currentStreak: 0                    | GET /streaks          |
| 5    | Verify default persona được tạo      | 1 default persona                   | GET /personas         |

**Test Data**:

```json
{
  "email": "newuser@test.com",
  "password": "SecurePass123",
  "username": "newuser123"
}
```

**Assertions**:

- [ ] accessToken is JWT format
- [ ] refreshToken is returned
- [ ] user.id is UUID
- [ ] user.level = "Beginner"
- [ ] user.totalXp = 0

---

#### TST-AUTH-002: User Login Flow

**Objective**: Kiểm tra luồng đăng nhập và token refresh

**Steps**:

| Step | Action                                 | Expected Result         | API           |
| ---- | -------------------------------------- | ----------------------- | ------------- |
| 1    | POST /auth/login với valid credentials | 200 OK, tokens          | /auth/login   |
| 2    | Use accessToken to call protected API  | 200 OK                  | GET /users/me |
| 3    | Wait or simulate token expiry          | -                       | -             |
| 4    | POST /auth/refresh với refreshToken    | 200 OK, new accessToken | /auth/refresh |
| 5    | Use new accessToken                    | 200 OK                  | GET /users/me |
| 6    | POST /auth/logout                      | 200 OK                  | /auth/logout  |
| 7    | Try to use old accessToken             | 401 Unauthorized        | GET /users/me |

---

#### TST-AUTH-003: Registration Validation Errors

**Objective**: Kiểm tra validation khi đăng ký

**Test Cases**:

| Case                 | Input                 | Expected Error |
| -------------------- | --------------------- | -------------- |
| Invalid email format | `email: "notanemail"` | 400, VAL_001   |
| Password too short   | `password: "short"`   | 400, VAL_002   |
| Invalid username     | `username: "a"`       | 400, VAL_003   |
| Duplicate email      | existing email        | 409, AUTH_001  |

---

#### TST-AUTH-004: OAuth Login Flow

**Objective**: Kiểm tra đăng nhập qua Google/Apple

**Steps**:

| Step | Action                                    | Expected Result      | API                |
| ---- | ----------------------------------------- | -------------------- | ------------------ |
| 1    | POST /auth/oauth/google với valid idToken | 200 OK, tokens, user | /auth/oauth/google |
| 2    | Verify user created/updated               | user data correct    | GET /users/me      |
| 3    | Repeat with same OAuth                    | Same user returned   | /auth/oauth/google |

---

### 3.2 User Profile Flow

#### TST-USER-001: Complete Profile Update Flow

**Objective**: Kiểm tra cập nhật và truy vấn profile

**Preconditions**: User đã đăng nhập

**Steps**:

| Step | Action                                 | Expected Result         | API             |
| ---- | -------------------------------------- | ----------------------- | --------------- |
| 1    | GET /users/me                          | Current user profile    | /users/me       |
| 2    | PUT /users/me với new username         | 200 OK, updated profile | /users/me       |
| 3    | PUT /users/me/settings với aiSpeed=1.5 | 200 OK                  | /users/me       |
| 4    | GET /users/me                          | Settings reflected      | /users/me       |
| 5    | GET /users/me/stats                    | Stats returned          | /users/me/stats |

**Test Data**:

```json
{
  "username": "updated_user",
  "aiSpeed": 1.5,
  "confirmationMode": true
}
```

**Assertions**:

- [ ] username updated correctly
- [ ] aiSpeed = 1.5
- [ ] stats includes streak, xp, conversations, vocabulary

---

#### TST-USER-002: Password Change Flow

**Objective**: Kiểm tra đổi mật khẩu

**Steps**:

| Step | Action                                     | Expected Result  | API                |
| ---- | ------------------------------------------ | ---------------- | ------------------ |
| 1    | PUT /users/me/password với valid passwords | 200 OK           | /users/me/password |
| 2    | Login with old password                    | 401 Unauthorized | /auth/login        |
| 3    | Login with new password                    | 200 OK, tokens   | /auth/login        |

---

### 3.3 Persona Management Flow

#### TST-PERSONA-001: Persona CRUD Flow

**Objective**: Kiểm tra quản lý AI persona

**Steps**:

| Step | Action                             | Expected Result           | API                       |
| ---- | ---------------------------------- | ------------------------- | ------------------------- |
| 1    | GET /personas                      | List with default persona | GET /personas             |
| 2    | POST /personas với custom persona  | 201 Created               | POST /personas            |
| 3    | GET /personas/:id                  | Persona details           | GET /personas/:id         |
| 4    | PUT /personas/:id                  | 200 OK, updated           | PUT /personas/:id         |
| 5    | PUT /personas/:id/default          | Set as default            | PUT /personas/:id/default |
| 6    | GET /personas                      | isDefault = true          | GET /personas             |
| 7    | DELETE /personas/:id (non-default) | 204 No Content            | DELETE /personas/:id      |

**Test Data**:

```json
{
  "name": "Business Mentor",
  "language": "en-US",
  "voiceType": "professional",
  "personality": "formal",
  "instructions": "Focus on business vocabulary"
}
```

---

### 3.4 Conversation Flow

#### TST-CONV-001: Complete Conversation Lifecycle

**Objective**: Kiểm tra luồng hội thoại từ đầu đến cuối

**Preconditions**: User có subscription, persona tồn tại

**Steps**:

| Step | Action                       | Expected Result          | API                          |
| ---- | ---------------------------- | ------------------------ | ---------------------------- |
| 1    | POST /conversations          | 201, websocketUrl, token | POST /conversations          |
| 2    | Connect WebSocket với token  | connected event          | WS /ws/conversation          |
| 3    | Send audio_stream events     | text_result events       | WS                           |
| 4    | Receive ai_response events   | audio chunks             | WS                           |
| 5    | POST /conversations/:id/end  | Summary, XP, badges      | POST /conversations/:id/end  |
| 6    | GET /conversations/:id       | Conversation details     | GET /conversations/:id       |
| 7    | GET /conversations/:id/turns | All turns                | GET /conversations/:id/turns |
| 8    | GET /conversations           | In list                  | GET /conversations           |

**Test Data**:

```json
{
  "mode": "instructor",
  "personaId": "{personaId}",
  "topic": "Daily conversation"
}
```

**Assertions**:

- [ ] websocketUrl is valid
- [ ] token expires in 5 minutes
- [ ] XP awarded after end
- [ ] corrections included in summary
- [ ] streak updated

---

#### TST-CONV-002: Roleplay Mode with Scenario

**Objective**: Kiểm tra hội thoại roleplay với scenario

**Steps**:

| Step | Action                                            | Expected Result                   | API                         |
| ---- | ------------------------------------------------- | --------------------------------- | --------------------------- |
| 1    | GET /scenarios                                    | List scenarios                    | GET /scenarios              |
| 2    | POST /conversations với mode=roleplay, scenarioId | Conversation created              | POST /conversations         |
| 3    | (conversation happens via WebSocket)              | -                                 | -                           |
| 4    | POST /conversations/:id/end                       | Summary includes scenario context | POST /conversations/:id/end |

---

#### TST-CONV-003: Usage Limit Check

**Objective**: Kiểm tra giới hạn sử dụng cho free user

**Preconditions**: Free user, đã dùng hết daily limit

**Steps**:

| Step | Action                             | Expected Result               | API                   |
| ---- | ---------------------------------- | ----------------------------- | --------------------- |
| 1    | Set user's dailyUsageCount = limit | -                             | DB Setup              |
| 2    | POST /conversations                | 403 Forbidden, ERR_BIZ_002    | POST /conversations   |
| 3    | GET /subscriptions/me              | Shows dailyUsageLimit reached | GET /subscriptions/me |

---

### 3.5 Learning Flow

#### TST-LEARN-001: Vocabulary Management Flow

**Objective**: Kiểm tra quản lý từ vựng và SRS

**Steps**:

| Step | Action                                             | Expected Result          | API                           |
| ---- | -------------------------------------------------- | ------------------------ | ----------------------------- |
| 1    | POST /vocabularies với new word                    | 201, srsLevel="new"      | POST /vocabularies            |
| 2    | GET /vocabularies                                  | Word in list             | GET /vocabularies             |
| 3    | GET /vocabularies/due                              | Word appears (if due)    | GET /vocabularies/due         |
| 4    | POST /vocabularies/:id/review với result="correct" | Level up, nextReviewDate | POST /vocabularies/:id/review |
| 5    | GET /vocabularies/:id                              | srsLevel changed         | GET /vocabularies             |

**Assertions**:

- [ ] srsLevel progression: new → learning → young → mature → mastered
- [ ] nextReviewDate calculated correctly based on SRS algorithm
- [ ] XP awarded on correct review

---

#### TST-LEARN-002: Scenario List and Filter

**Objective**: Kiểm tra lọc và hiển thị scenarios

**Steps**:

| Step | Action                             | Expected Result  | API                |
| ---- | ---------------------------------- | ---------------- | ------------------ |
| 1    | GET /scenarios                     | All scenarios    | GET /scenarios     |
| 2    | GET /scenarios?category=business   | Only business    | GET /scenarios     |
| 3    | GET /scenarios?difficulty=advanced | Only advanced    | GET /scenarios     |
| 4    | GET /scenarios/:id                 | Scenario details | GET /scenarios/:id |

---

#### TST-LEARN-003: Daily Challenge Flow

**Objective**: Kiểm tra challenges hàng ngày

**Steps**:

| Step | Action                                  | Expected Result         | API                   |
| ---- | --------------------------------------- | ----------------------- | --------------------- |
| 1    | GET /challenges/today                   | Today's challenges      | GET /challenges/today |
| 2    | Complete condition (e.g., conversation) | -                       | Other APIs            |
| 3    | GET /challenges/today                   | Progress updated        | GET /challenges/today |
| 4    | Complete challenge fully                | status: "completed", XP | GET /challenges/today |

---

### 3.6 Gamification Flow

#### TST-GAME-001: Streak Management

**Objective**: Kiểm tra streak tracking và freeze

**Steps**:

| Step | Action                              | Expected Result             | API                   |
| ---- | ----------------------------------- | --------------------------- | --------------------- |
| 1    | GET /streaks                        | Current streak info         | GET /streaks          |
| 2    | Complete daily activity             | -                           | (conversation/review) |
| 3    | GET /streaks                        | currentStreak incremented   | GET /streaks          |
| 4    | POST /streaks/freeze với valid date | freezeRemaining decremented | POST /streaks/freeze  |
| 5    | GET /streaks                        | Freeze used                 | GET /streaks          |

**Assertions**:

- [ ] Streak reset if no activity for 1 day (without freeze)
- [ ] Freeze prevents streak reset
- [ ] longestStreak updated when currentStreak exceeds it

---

#### TST-GAME-002: Badge Award Flow

**Objective**: Kiểm tra việc nhận badge tự động

**Steps**:

| Step | Action                                        | Expected Result         | API              |
| ---- | --------------------------------------------- | ----------------------- | ---------------- |
| 1    | GET /badges                                   | All available badges    | GET /badges      |
| 2    | GET /badges/mine                              | Currently earned badges | GET /badges/mine |
| 3    | Complete badge condition (e.g., 7-day streak) | -                       | Activity         |
| 4    | GET /badges/mine                              | New badge appears       | GET /badges/mine |
| 5    | Check XP bonus awarded                        | totalXp increased       | GET /users/me    |

---

#### TST-GAME-003: Weekly Ranking

**Objective**: Kiểm tra bảng xếp hạng tuần

**Steps**:

| Step | Action                            | Expected Result                  | API                  |
| ---- | --------------------------------- | -------------------------------- | -------------------- |
| 1    | GET /rankings/weekly              | Rankings list                    | GET /rankings/weekly |
| 2    | Earn XP (via conversation/review) | -                                | -                    |
| 3    | GET /rankings/weekly              | myRank updated, position changed | GET /rankings/weekly |
| 4    | GET /rankings/weekly?league=Gold  | Filter by league                 | GET /rankings/weekly |

---

### 3.7 Social Flow

#### TST-SOCIAL-001: Invitation Flow

**Objective**: Kiểm tra hệ thống mời bạn bè

**Users**: testUser1 (sender), testUser2 (receiver)

**Steps**:

| Step | Action                                   | Expected Result    | API                      |
| ---- | ---------------------------------------- | ------------------ | ------------------------ |
| 1    | User1: POST /invitations                 | code, shareUrl     | POST /invitations        |
| 2    | User1: GET /invitations/mine             | Invitation in list | GET /invitations/mine    |
| 3    | User2: POST /invitations/accept với code | bonusXp awarded    | POST /invitations/accept |
| 4    | User1: GET /invitations/mine             | status: "accepted" | GET /invitations/mine    |
| 5    | User1: Check XP                          | bonusXp added      | GET /users/me            |

**Assertions**:

- [ ] Both users receive XP bonus
- [ ] Invitation status changes to "accepted"
- [ ] Cannot accept same invitation twice

---

#### TST-SOCIAL-002: Group Management

**Objective**: Kiểm tra quản lý nhóm học tập

**Steps**:

| Step | Action                        | Expected Result     | API                     |
| ---- | ----------------------------- | ------------------- | ----------------------- |
| 1    | POST /groups                  | 201, group created  | POST /groups            |
| 2    | GET /groups                   | Group in list       | GET /groups             |
| 3    | GET /groups/:id               | Group details       | GET /groups/:id         |
| 4    | User2: POST /groups/:id/join  | Joined successfully | POST /groups/:id/join   |
| 5    | GET /groups/:id/members       | Both users in list  | GET /groups/:id/members |
| 6    | User2: POST /groups/:id/leave | Left successfully   | POST /groups/:id/leave  |
| 7    | GET /groups/:id/members       | Only owner          | GET /groups/:id/members |

---

### 3.8 Subscription Flow

#### TST-SUB-001: Subscription Status Check

**Objective**: Kiểm tra trạng thái subscription

**Steps**:

| Step | Action                               | Expected Result           | API                   |
| ---- | ------------------------------------ | ------------------------- | --------------------- |
| 1    | GET /subscriptions/me (free user)    | plan: "free", limits      | GET /subscriptions/me |
| 2    | GET /subscriptions/me (premium user) | plan: "premium", features | GET /subscriptions/me |

**Assertions**:

- [ ] Free: dailyUsageLimit = 3, unlimitedConversations = false
- [ ] Premium: unlimitedConversations = true, allPersonas = true

---

#### TST-SUB-002: Purchase Flow (Mocked)

**Objective**: Kiểm tra luồng mua subscription (với mock receipt)

**Steps**:

| Step | Action                                        | Expected Result             | API                          |
| ---- | --------------------------------------------- | --------------------------- | ---------------------------- |
| 1    | POST /subscriptions/purchase với mock receipt | 200, subscription updated   | POST /subscriptions/purchase |
| 2    | GET /subscriptions/me                         | plan: "premium"             | GET /subscriptions/me        |
| 3    | GET /badges/mine                              | First Premium badge awarded | GET /badges/mine             |

---

### 3.9 Translation Flow

#### TST-TRANS-001: Direct Translation Practice

**Objective**: Kiểm tra luồng luyện dịch trực tiếp

**Steps**:

| Step | Action                                 | Expected Result   | API                        |
| ---- | -------------------------------------- | ----------------- | -------------------------- |
| 1    | GET /translation/questions?topic=daily | Question data     | GET /translation/questions |
| 2    | POST /translation/answers với audio    | Scores, feedback  | POST /translation/answers  |
| 3    | Check XP earned                        | totalXp increased | GET /users/me              |
| 4    | Repeat until daily limit               | 429 on limit      | GET /translation/questions |

**Test Data**:

```json
{
  "questionId": "{id}",
  "audio": "<base64_audio>",
  "responseTimeSec": 15
}
```

**Assertions**:

- [ ] totalScore 0-100
- [ ] grammarScore, vocabScore, speedScore included
- [ ] modelAnswer provided
- [ ] feedback.goodPoints, feedback.improvements arrays

---

#### TST-TRANS-002: Intent Translation (Level Restricted)

**Objective**: Kiểm tra tính năng yêu cầu level Intermediate+

**Steps**:

| Step | Action                                                | Expected Result                | API                               |
| ---- | ----------------------------------------------------- | ------------------------------ | --------------------------------- |
| 1    | (Beginner User) GET /translation/intent-questions     | 403 Forbidden, TRANS_LEVEL_001 | GET /translation/intent-questions |
| 2    | (Intermediate User) GET /translation/intent-questions | 200 OK, question               | GET /translation/intent-questions |
| 3    | POST /translation/intent-answers                      | Evaluation result              | POST /translation/intent-answers  |

---

#### TST-TRANS-003: Quick Response - Word Association

**Objective**: Kiểm tra Word Association Challenge

**Steps**:

| Step | Action                                                 | Expected Result                | API             |
| ---- | ------------------------------------------------------ | ------------------------------ | --------------- |
| 1    | POST /quick-response/word-association/start            | sessionId, firstKeyword        | POST .../start  |
| 2    | POST /quick-response/word-association/answer với audio | correct/incorrect, nextKeyword | POST .../answer |
| 3    | Loop until nextKeyword is null or timeout              | -                              | -               |
| 4    | POST /quick-response/word-association/end              | Final score, XP                | POST .../end    |

---

#### TST-TRANS-004: Quick Response - Instant Drill

**Objective**: Kiểm tra Instant Drill

**Steps**:

| Step | Action                                    | Expected Result           | API             |
| ---- | ----------------------------------------- | ------------------------- | --------------- |
| 1    | POST /quick-response/instant-drill/start  | sessionId, totalQuestions | POST .../start  |
| 2    | GET /quick-response/instant-drill/next    | Next question             | GET .../next    |
| 3    | POST /quick-response/instant-drill/answer | Score                     | POST .../answer |
| 4    | Repeat for totalQuestions                 | -                         | -               |
| 5    | POST /quick-response/instant-drill/end    | Summary, XP               | POST .../end    |

---

#### TST-TRANS-005: Shadowing Practice

**Objective**: Kiểm tra Shadowing Flow

**Steps**:

| Step | Action                                             | Expected Result           | API                         |
| ---- | -------------------------------------------------- | ------------------------- | --------------------------- |
| 1    | GET /shadowing/contents                            | Content list              | GET /shadowing/contents     |
| 2    | GET /shadowing/contents/:id                        | Content details, audioUrl | GET /shadowing/contents/:id |
| 3    | POST /shadowing/sessions/start với contentId       | sessionId                 | POST .../start              |
| 4    | POST /shadowing/sessions/:id/analyze với userAudio | Analysis scores           | POST .../analyze            |

**Assertions**:

- [ ] Premium content locked for free users (isLocked: true)
- [ ] Analysis includes: followingScore, pronunciationScore, rhythmScore
- [ ] weakSegments array identifies problem areas

---

### 3.10 WebSocket Flow

#### TST-WS-001: WebSocket Connection and Communication

**Objective**: Kiểm tra WebSocket realtime

**Steps**:

| Step | Action                               | Expected Result     | API                 |
| ---- | ------------------------------------ | ------------------- | ------------------- |
| 1    | POST /conversations                  | websocketUrl, token | POST /conversations |
| 2    | Connect WebSocket với token          | -                   | WS Connect          |
| 3    | Wait for 'connected' event           | sessionId           | WS Event            |
| 4    | Send 'audio_stream' event            | -                   | WS Event            |
| 5    | Wait for 'text_result' events        | text, isFinal       | WS Event            |
| 6    | Wait for 'ai_response_start'         | responseId          | WS Event            |
| 7    | Wait for 'ai_response_audio' chunks  | audio chunks        | WS Event            |
| 8    | Wait for 'ai_response_end'           | full text           | WS Event            |
| 9    | Wait for 'correction' event (if any) | corrections array   | WS Event            |
| 10   | Wait for 'suggestion' event          | suggestions         | WS Event            |
| 11   | Send 'disconnect'                    | Close connection    | WS Event            |

---

#### TST-WS-002: WebSocket Interrupt Flow

**Objective**: Kiểm tra ngắt AI response

**Steps**:

| Step | Action                                        | Expected Result | API          |
| ---- | --------------------------------------------- | --------------- | ------------ |
| 1    | Start conversation, receive ai_response_start | -               | -            |
| 2    | Send 'interrupt' event                        | -               | WS interrupt |
| 3    | Wait for 'processing_stopped'                 | message         | WS Event     |
| 4    | No more ai_response_audio events              | -               | -            |

---

#### TST-WS-003: WebSocket Error Handling

**Objective**: Kiểm tra xử lý lỗi WebSocket

**Test Cases**:

| Case                 | Action                    | Expected Error |
| -------------------- | ------------------------- | -------------- |
| Invalid token        | Connect với expired token | WS_ERR_001     |
| Session expired      | Keep connection too long  | WS_ERR_002     |
| Invalid audio format | Send malformed audio      | WS_ERR_006     |

---

## 4. Cross-API Integration Tests

### TST-CROSS-001: Full User Journey - New User to First Conversation

**Objective**: Kiểm tra journey hoàn chỉnh của user mới

**Scenario**: Một người dùng mới đăng ký, tạo persona, và thực hiện cuộc hội thoại đầu tiên

**Steps**:

| Step | Action                    | API                         |
| ---- | ------------------------- | --------------------------- |
| 1    | Register new user         | POST /auth/register         |
| 2    | Get user profile          | GET /users/me               |
| 3    | Get subscription status   | GET /subscriptions/me       |
| 4    | Get default persona       | GET /personas               |
| 5    | Update user settings      | PUT /users/me               |
| 6    | Get scenarios             | GET /scenarios              |
| 7    | Create conversation       | POST /conversations         |
| 8    | WebSocket conversation    | WS /ws/conversation         |
| 9    | End conversation          | POST /conversations/:id/end |
| 10   | Check XP earned           | GET /users/me               |
| 11   | Check streak updated      | GET /streaks                |
| 12   | Check challenges progress | GET /challenges/today       |
| 13   | Get conversation history  | GET /conversations          |

**Assertions**:

- [ ] All steps complete successfully
- [ ] Data consistency across APIs
- [ ] XP, streak, challenges all updated correctly

---

### TST-CROSS-002: Vocabulary Addition from Conversation

**Objective**: Kiểm tra việc thêm từ vựng từ hội thoại

**Steps**:

| Step | Action                                 | Expected                 |
| ---- | -------------------------------------- | ------------------------ |
| 1    | Complete conversation with corrections | corrections array        |
| 2    | POST /vocabularies với conversationId  | Linked to conversation   |
| 3    | GET /vocabularies                      | Word with conversationId |
| 4    | GET /conversations/:id/turns           | Corrections visible      |

---

### TST-CROSS-003: Gamification Triggers

**Objective**: Kiểm tra badge được award qua các hoạt động

**Scenarios**:

| Activity                 | Expected Badge     |
| ------------------------ | ------------------ |
| First conversation       | first_conversation |
| 7-day streak             | week_warrior       |
| Complete 10 vocabularies | vocab_starter      |
| First premium purchase   | premium_member     |

---

### TST-CROSS-004: Usage Limit Across Features

**Objective**: Kiểm tra usage limit áp dụng đúng cho từng tính năng

**Free User Limits**:

| Feature               | Limit  | Test            |
| --------------------- | ------ | --------------- |
| Conversations         | 3/day  | 4th call → 403  |
| Translation questions | 10/day | 11th call → 429 |
| Quick response        | 3/day  | 4th call → 429  |

---

## 5. Error Handling Tests

### TST-ERR-001: Authentication Errors

| Test Case     | Input                   | Expected          |
| ------------- | ----------------------- | ----------------- |
| Missing token | No Authorization header | 401               |
| Invalid token | `Bearer invalid`        | 401               |
| Expired token | Expired JWT             | 401, ERR_AUTH_002 |
| Wrong format  | Basic auth header       | 401               |

---

### TST-ERR-002: Validation Errors

| Test Case                    | Input               | Expected         |
| ---------------------------- | ------------------- | ---------------- |
| Missing required field       | `{}` for register   | 400, VAL_001     |
| Invalid email                | `email: "notvalid"` | 400, VAL_001     |
| String where number expected | `aiSpeed: "fast"`   | 400              |
| Out of range                 | `aiSpeed: 5.0`      | 400, ERR_VAL_006 |

---

### TST-ERR-003: Resource Not Found Errors

| Test Case                 | Input                                      | Expected         |
| ------------------------- | ------------------------------------------ | ---------------- |
| Non-existent user ID      | GET /users/{invalidId}                     | 404              |
| Non-existent conversation | GET /conversations/{invalidId}             | 404              |
| Non-existent persona      | POST /conversations with invalid personaId | 404, ERR_RES_001 |

---

### TST-ERR-004: Business Logic Errors

| Test Case                      | Condition           | Expected         |
| ------------------------------ | ------------------- | ---------------- |
| Delete default persona         | Only persona        | 403 or 400       |
| Accept own invitation          | Same user           | 400, ERR_BIZ_011 |
| Join full group                | maxMembers reached  | 403, ERR_BIZ_007 |
| Use more freeze than available | freezeRemaining = 0 | 403, ERR_BIZ_005 |

---

### TST-ERR-005: External Service Errors

| Test Case        | Condition           | Expected               |
| ---------------- | ------------------- | ---------------------- |
| OpenAI timeout   | Mock timeout        | 503, ERR_EXT_001       |
| STT service down | Mock error          | 503, graceful fallback |
| Invalid receipt  | Invalid iOS receipt | 400, ERR_BIZ_008       |

---

## 6. Performance Tests

### TST-PERF-001: Response Time Benchmarks

| API                       | Target | Max    |
| ------------------------- | ------ | ------ |
| GET /users/me             | 50ms   | 200ms  |
| GET /conversations (list) | 100ms  | 500ms  |
| POST /conversations       | 100ms  | 500ms  |
| GET /vocabularies/due     | 100ms  | 300ms  |
| GET /rankings/weekly      | 200ms  | 1000ms |

---

### TST-PERF-002: Concurrent Users

| Test               | Concurrent Users | Expected          |
| ------------------ | ---------------- | ----------------- |
| Login burst        | 100              | All succeed, < 1s |
| Conversation start | 50               | All succeed, < 2s |
| Ranking query      | 200              | All succeed, < 3s |

---

### TST-PERF-003: WebSocket Performance

| Metric                    | Target  |
| ------------------------- | ------- |
| Connection time           | < 100ms |
| Audio to text latency     | < 300ms |
| AI response start latency | < 500ms |

---

## 7. Test Execution Checklist

### Pre-execution

- [ ] Database seeded
- [ ] External services mocked
- [ ] Redis cleared
- [ ] Test accounts created

### Execution Order

1. [ ] Auth Flow tests
2. [ ] User Flow tests
3. [ ] Persona Flow tests
4. [ ] Learning Flow tests
5. [ ] Gamification Flow tests
6. [ ] Conversation Flow tests
7. [ ] Social Flow tests
8. [ ] Subscription Flow tests
9. [ ] Translation Flow tests
10. [ ] WebSocket tests
11. [ ] Cross-API tests
12. [ ] Error handling tests
13. [ ] Performance tests

### Post-execution

- [ ] Generate test report
- [ ] Document failed tests
- [ ] Create tickets for bugs
- [ ] Update test status

---

## 8. Test Report Template

```markdown
## Test Report - [Date]

### Summary

- Total: XX tests
- Passed: XX (XX%)
- Failed: XX (XX%)
- Skipped: XX

### Failed Tests

| Test ID     | Description | Error | Priority        |
| ----------- | ----------- | ----- | --------------- |
| TST-XXX-XXX | ...         | ...   | High/Medium/Low |

### Notes

- ...

### Next Steps

- ...
```

---

## Appendix A: API Endpoints Summary

| Category     | Count     | Status |
| ------------ | --------- | ------ |
| Auth         | 7         | ✅     |
| User         | 5         | ✅     |
| Persona      | 6         | ✅     |
| Conversation | 5         | ✅     |
| Learning     | 7         | ✅     |
| Gamification | 5         | ✅     |
| Subscription | 3         | ✅     |
| Social       | 9         | ✅     |
| Translation  | 15        | ✅     |
| WebSocket    | 10 events | ✅     |
| **Total**    | **72**    | ✅     |

---

## Appendix B: Error Codes Reference

| Category       | Prefix   | Example     |
| -------------- | -------- | ----------- |
| Validation     | VAL\_    | VAL_001     |
| Auth           | AUTH\_   | AUTH_002    |
| Resource       | ERR*RES* | ERR_RES_001 |
| Business       | ERR*BIZ* | ERR_BIZ_002 |
| External       | ERR*EXT* | ERR_EXT_001 |
| WebSocket      | WS*ERR*  | WS_ERR_001  |
| Translation    | TRANS\_  | TRANS_001   |
| Quick Response | QR\_     | QR_001      |
| Shadowing      | SHADOW\_ | SHADOW_001  |
