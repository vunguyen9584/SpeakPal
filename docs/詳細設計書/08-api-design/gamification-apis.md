# 8.7. Gamification APIs

## API-401: GET /streaks

### Response

```typescript
interface StreakResponse {
  currentStreak: number;
  longestStreak: number;
  freezeRemaining: number;
  lastActivityDate: string | null;
  streakMilestones: {
    next: number; // Next milestone (7, 30, 100...)
    daysRemaining: number;
    badge: Badge | null; // Badge to earn
  };
}
```

---

## API-402: POST /streaks/freeze

### Request

```typescript
interface UseFreezeRequest {
  date: string; // ISO date to freeze
}
```

### Response

```typescript
interface UseFreezeResponse {
  success: boolean;
  freezeRemaining: number;
  message: string;
}
```

### Error Responses

| Status | Code        | Message             |
| ------ | ----------- | ------------------- |
| 403    | ERR_BIZ_005 | No freeze remaining |
| 400    | ERR_BIZ_006 | Invalid freeze date |

---

## API-403: GET /badges

### Response

```typescript
interface BadgeListResponse {
  data: Badge[];
}

interface Badge {
  id: string;
  code: string;
  name: string;
  nameJa: string;
  description: string;
  category: "streak" | "level" | "conversation" | "vocabulary" | "special";
  iconUrl: string;
  xpBonus: number;
  condition: object;
}
```

---

## API-404: GET /badges/mine

### Response

```typescript
interface MyBadgesResponse {
  data: EarnedBadge[];
  totalXpBonus: number;
}

interface EarnedBadge {
  badge: Badge;
  earnedAt: string;
}
```

---

## API-405: GET /rankings/weekly

### Query Parameters

| Parameter | Type   | Required | Description           |
| --------- | ------ | -------- | --------------------- |
| league    | string | No       | Filter by league      |
| limit     | number | No       | Default: 50, Max: 100 |

### Response

```typescript
interface RankingResponse {
  league: string;
  weekNumber: number;
  myRank: number | null;
  data: RankingEntry[];
}

interface RankingEntry {
  rank: number;
  userId: string;
  username: string;
  weeklyXp: number;
  change: "up" | "down" | "same";
  isCurrentUser: boolean;
}
```

---

← [Learning APIs](./learning-apis.md) | _次: [Subscription APIs](./subscription-apis.md)_
