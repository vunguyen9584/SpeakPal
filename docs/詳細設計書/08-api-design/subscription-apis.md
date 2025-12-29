# 8.8. Subscription APIs

## API-501: GET /subscriptions/me

### Response

```typescript
interface SubscriptionResponse {
  plan: "free" | "premium" | "premium_plus";
  dailyUsageCount: number;
  dailyUsageLimit: number;
  expiresAt: string | null;
  features: {
    unlimitedConversations: boolean;
    allPersonas: boolean;
    detailedPronunciation: boolean;
    prioritySupport: boolean;
  };
}
```

---

## API-502: POST /subscriptions/purchase

### Request

```typescript
interface PurchaseRequest {
  receipt: string; // App Store / Play Store receipt
  platform: "ios" | "android";
  productId: string;
}
```

### Response

```typescript
interface PurchaseResponse {
  success: boolean;
  subscription: SubscriptionResponse;
  message: string;
}
```

### Processing Steps

1. Validate receipt with App Store / Play Store
2. Extract product info and expiry date
3. Map product to plan
4. Update subscription in database
5. Award first premium badge if applicable
6. Return updated subscription

### Error Responses

| Status | Code        | Message              |
| ------ | ----------- | -------------------- |
| 400    | ERR_BIZ_008 | Invalid receipt      |
| 400    | ERR_BIZ_009 | Receipt already used |
| 503    | ERR_EXT_004 | Store unavailable    |

---

## API-503: POST /subscriptions/restore

### Request

```typescript
interface RestoreRequest {
  receipt: string;
  platform: "ios" | "android";
}
```

### Response

Same as PurchaseResponse

---

← [Gamification APIs](./gamification-apis.md) | _次: [Social APIs](./social-apis.md)_
