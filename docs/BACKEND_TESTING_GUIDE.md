# 🧪 Testing Guide - New Backend Endpoints

**Date:** 2026-01-12  
**Purpose:** Quick testing guide for newly implemented endpoints

---

## 🔧 Prerequisites

1. Backend server running: `npm run start:dev`
2. Database seeded with test data
3. Valid JWT token for authenticated requests

### Get JWT Token

```bash
# Login to get token
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'

# Save the token
export TOKEN="your_jwt_token_here"
```

---

## 📝 Test Commands

### 1. Subscription Plans (Public - No Auth)

```bash
# Get available subscription plans
curl -X GET http://localhost:3000/subscriptions/plans \
  -H "Content-Type: application/json"

# Expected Response:
# [
#   {
#     "id": "free",
#     "name": "Free",
#     "price": "$0",
#     "features": [...],
#     "isPopular": false
#   },
#   ...
# ]
```

---

### 2. Progress - Weekly Report

```bash
# Get current week report
curl -X GET http://localhost:3000/progress/weekly-report \
  -H "Authorization: Bearer $TOKEN"

# Get previous week (offset = 1)
curl -X GET "http://localhost:3000/progress/weekly-report?week=1" \
  -H "Authorization: Bearer $TOKEN"

# Expected Response:
# {
#   "weekNumber": 1,
#   "startDate": "2026-01-06",
#   "endDate": "2026-01-12",
#   "totalXP": 150,
#   "totalMinutes": 45,
#   "conversationsCompleted": 10,
#   "vocabularyLearned": 25,
#   "averageScore": 85,
#   "dailyBreakdown": [...]
# }
```

---

### 3. Progress - Monthly Report

```bash
# Get current month report
curl -X GET http://localhost:3000/progress/monthly-report \
  -H "Authorization: Bearer $TOKEN"

# Get previous month (offset = 1)
curl -X GET "http://localhost:3000/progress/monthly-report?month=1" \
  -H "Authorization: Bearer $TOKEN"

# Expected Response:
# {
#   "monthNumber": 1,
#   "year": 2026,
#   "startDate": "2026-01-01",
#   "endDate": "2026-01-31",
#   "totalXP": 500,
#   "totalMinutes": 180,
#   "conversationsCompleted": 40,
#   "vocabularyLearned": 100,
#   "averageScore": 85,
#   "dailyBreakdown": [...]
# }
```

---

### 4. Progress - Learning History

```bash
# Get all learning history (page 1, 20 items)
curl -X GET "http://localhost:3000/progress/history?page=1&limit=20" \
  -H "Authorization: Bearer $TOKEN"

# Get only conversations
curl -X GET "http://localhost:3000/progress/history?page=1&limit=20&type=conversation" \
  -H "Authorization: Bearer $TOKEN"

# Get only vocabulary
curl -X GET "http://localhost:3000/progress/history?page=1&limit=20&type=vocabulary" \
  -H "Authorization: Bearer $TOKEN"

# Expected Response:
# {
#   "items": [
#     {
#       "id": "uuid",
#       "type": "conversation",
#       "title": "Conversation - FREETALK",
#       "completedAt": "2026-01-12T10:00:00Z",
#       "score": 85,
#       "xpEarned": 10,
#       "duration": 300
#     }
#   ],
#   "total": 50,
#   "page": 1,
#   "totalPages": 3
# }
```

---

### 5. Learning - Review Quiz Result

```bash
# Record quiz result
curl -X POST http://localhost:3000/learning/review/result \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "quizId": "quiz-123",
    "score": 85,
    "correctAnswers": 17,
    "totalQuestions": 20,
    "timeSpent": 120,
    "answers": [
      {
        "questionId": "q1",
        "userAnswer": "answer1",
        "correct": true
      },
      {
        "questionId": "q2",
        "userAnswer": "answer2",
        "correct": false
      }
    ]
  }'

# Expected Response:
# {
#   "success": true,
#   "xpEarned": 42,
#   "score": 85,
#   "correctAnswers": 17,
#   "totalQuestions": 20,
#   "message": "Great job! You earned 42 XP"
# }
```

---

### 6. User - Upload Avatar

```bash
# Upload avatar image
curl -X POST http://localhost:3000/users/me/avatar \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@/path/to/avatar.jpg"

# Expected Response:
# {
#   "avatarUrl": "/uploads/avatars/avatar-user-id-1234567890.jpg"
# }
```

**PowerShell Version:**

```powershell
# Create form data
$form = @{
    file = Get-Item -Path "C:\path\to\avatar.jpg"
}

# Upload
Invoke-RestMethod -Uri "http://localhost:3000/users/me/avatar" `
  -Method Post `
  -Headers @{ "Authorization" = "Bearer $TOKEN" } `
  -Form $form
```

---

## 🧪 Postman Collection

### Import Collection

Create a new Postman collection with these requests:

1. **Subscription Plans**

   - Method: GET
   - URL: `{{baseUrl}}/subscriptions/plans`
   - Auth: None

2. **Weekly Report**

   - Method: GET
   - URL: `{{baseUrl}}/progress/weekly-report?week=0`
   - Auth: Bearer Token

3. **Monthly Report**

   - Method: GET
   - URL: `{{baseUrl}}/progress/monthly-report?month=0`
   - Auth: Bearer Token

4. **Learning History**

   - Method: GET
   - URL: `{{baseUrl}}/progress/history?page=1&limit=20&type=all`
   - Auth: Bearer Token

5. **Record Quiz Result**

   - Method: POST
   - URL: `{{baseUrl}}/learning/review/result`
   - Auth: Bearer Token
   - Body: JSON (see example above)

6. **Upload Avatar**
   - Method: POST
   - URL: `{{baseUrl}}/users/me/avatar`
   - Auth: Bearer Token
   - Body: form-data
     - Key: `file`
     - Type: File
     - Value: Select image file

### Environment Variables

```json
{
  "baseUrl": "http://localhost:3000",
  "token": "your_jwt_token_here"
}
```

---

## ✅ Validation Checklist

### For Each Endpoint:

- [ ] Returns 200 OK for valid requests
- [ ] Returns 401 Unauthorized without token (except public endpoints)
- [ ] Returns correct data structure
- [ ] Handles pagination correctly (where applicable)
- [ ] Validates input data (returns 400 for invalid input)
- [ ] Returns appropriate error messages

### Specific Tests:

**Subscription Plans:**

- [ ] Returns 3 plans (free, premium_monthly, premium_yearly)
- [ ] Each plan has: id, name, price, features[], isPopular
- [ ] Works without authentication

**Weekly/Monthly Reports:**

- [ ] Returns correct date ranges
- [ ] Daily breakdown has 7 days (weekly) or 28-31 days (monthly)
- [ ] XP and minutes are calculated correctly
- [ ] Offset parameter works correctly

**Learning History:**

- [ ] Pagination works (page, limit)
- [ ] Type filter works (conversation, vocabulary, all)
- [ ] Items are sorted by completedAt (newest first)
- [ ] Total count is accurate

**Review Quiz:**

- [ ] XP is awarded correctly (max 50 XP)
- [ ] User's totalXp is updated
- [ ] Returns success message

**Avatar Upload:**

- [ ] Accepts JPEG and PNG files
- [ ] Rejects files > 5MB
- [ ] Rejects non-image files
- [ ] Returns valid avatar URL
- [ ] File is saved to uploads/avatars/

---

## 🐛 Common Issues

### 1. 401 Unauthorized

**Problem:** Token is invalid or expired

**Solution:**

```bash
# Get a new token
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

### 2. Empty Data in Reports

**Problem:** No data in weekly/monthly reports

**Solution:** Create some test data first:

```bash
# Create a conversation
curl -X POST http://localhost:3000/conversations \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{...}'
```

### 3. File Upload Fails

**Problem:** Avatar upload returns 400

**Possible Causes:**

- File is too large (> 5MB)
- File is not JPEG/PNG
- Form field name is not "file"

**Solution:**

- Check file size: `ls -lh avatar.jpg`
- Check file type: `file avatar.jpg`
- Ensure field name is exactly "file"

---

## 📊 Performance Testing

### Load Test with Apache Bench

```bash
# Test subscription plans endpoint (100 requests, 10 concurrent)
ab -n 100 -c 10 http://localhost:3000/subscriptions/plans

# Test weekly report (with auth)
ab -n 100 -c 10 -H "Authorization: Bearer $TOKEN" \
  http://localhost:3000/progress/weekly-report
```

### Expected Performance:

- Subscription plans: < 50ms
- Weekly/Monthly reports: < 200ms
- Learning history: < 300ms
- Quiz result: < 100ms
- Avatar upload: < 500ms (depends on file size)

---

## 📝 Test Results Template

```markdown
## Test Results - [Date]

### Endpoint: [Name]

- **Status:** ✅ Pass / ❌ Fail
- **Response Time:** [ms]
- **Issues Found:** [None / List issues]
- **Notes:** [Any observations]

### Example:

## Test Results - 2026-01-12

### Endpoint: GET /subscriptions/plans

- **Status:** ✅ Pass
- **Response Time:** 45ms
- **Issues Found:** None
- **Notes:** Returns all 3 plans correctly

### Endpoint: GET /progress/weekly-report

- **Status:** ✅ Pass
- **Response Time:** 180ms
- **Issues Found:** None
- **Notes:** Daily breakdown has correct 7 days
```

---

**Last Updated:** 2026-01-12  
**Tested By:** [Your Name]  
**Backend Version:** 0.0.1
