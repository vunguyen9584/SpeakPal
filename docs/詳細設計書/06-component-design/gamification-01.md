# 6.8. Gamification Use Cases (UC-018 ～ UC-020)

## UC-018: 学習ストリーク

### Pseudocode

```typescript
async function recordActivity(userId: string): Promise<Streak> {
  const streak = await getStreak(userId);
  const today = getToday();
  const yesterday = getYesterday();

  if (isSameDay(streak.lastActivityDate, today)) {
    return streak; // 今日既に記録済み
  }

  if (isSameDay(streak.lastActivityDate, yesterday)) {
    streak.currentStreak += 1;
  } else if (streak.lastActivityDate < yesterday) {
    if (streak.freezeRemaining > 0) {
      streak.freezeRemaining -= 1;
    } else {
      streak.currentStreak = 1;
    }
  }

  streak.lastActivityDate = today;
  streak.longestStreak = Math.max(streak.longestStreak, streak.currentStreak);

  await save(streak);
  await badgeService.checkAndAward(userId, "STREAK_" + streak.currentStreak);

  return streak;
}
```

---

## UC-019: アチーブメントバッジ

### バッジ条件

| バッジ ID    | 条件              |
| ------------ | ----------------- |
| STREAK_7     | 7 日連続学習      |
| STREAK_30    | 30 日連続学習     |
| LEVEL_5      | レベル 5 達成     |
| CONV_FIRST   | 初回会話完了      |
| CONV_100     | 会話 100 回達成   |
| PRON_PERFECT | 発音スコア 100 点 |
| VOCAB_100    | 語彙 100 個登録   |

---

## UC-020: 経験値/レベル

### レベルアップ閾値

| レベル | 必要 XP |
| ------ | ------- |
| 1→2    | 100     |
| 2→3    | 200     |
| 3→4    | 400     |
| 4→5    | 800     |
| 5→6    | 1,600   |

---

← [Learning UCs](./learning-01.md) | _次: [Progress UCs](./progress-01.md)_
