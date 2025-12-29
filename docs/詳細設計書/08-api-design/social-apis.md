# 8.9. Social APIs

## API-601: POST /invitations

### Response

```typescript
interface InvitationResponse {
  id: string;
  code: string; // 8-char alphanumeric
  status: "pending";
  bonusXp: number;
  expiresAt: string;
  shareUrl: string; // Deep link URL
}
```

### Error Responses

| Status | Code        | Message                 |
| ------ | ----------- | ----------------------- |
| 403    | ERR_BIZ_010 | Max invitations reached |

---

## API-602: POST /invitations/accept

### Request

```typescript
interface AcceptInvitationRequest {
  code: string;
}
```

### Response

```typescript
interface AcceptInvitationResponse {
  success: boolean;
  bonusXp: number;
  sender: {
    id: string;
    username: string;
  };
}
```

### Error Responses

| Status | Code        | Message                |
| ------ | ----------- | ---------------------- |
| 404    | ERR_RES_003 | Invitation not found   |
| 400    | ERR_BIZ_006 | Already used           |
| 400    | ERR_BIZ_011 | Cannot invite yourself |
| 410    | ERR_BIZ_012 | Invitation expired     |

---

## API-603: GET /invitations/mine

### Response

```typescript
interface MyInvitationsResponse {
  data: Invitation[];
  totalAccepted: number;
  totalBonusXp: number;
}

interface Invitation {
  id: string;
  code: string;
  status: "pending" | "accepted" | "expired";
  receiver?: {
    username: string;
  };
  createdAt: string;
  usedAt: string | null;
}
```

---

## API-604: GET /groups

### Response

```typescript
interface GroupListResponse {
  data: GroupSummary[];
}

interface GroupSummary {
  id: string;
  name: string;
  memberCount: number;
  maxMembers: number;
  isOwner: boolean;
  joinedAt: string;
}
```

---

## API-605: POST /groups

### Request

```typescript
interface CreateGroupRequest {
  name: string; // 3-100 chars
  description?: string;
  maxMembers?: number; // Default: 10, Max: 50
}
```

### Response

```typescript
interface GroupResponse {
  id: string;
  name: string;
  description: string;
  maxMembers: number;
  owner: { id: string; username: string };
  createdAt: string;
}
```

---

## API-606: POST /groups/:id/join

### Response

```json
{
  "success": true,
  "data": {
    "message": "Joined group successfully",
    "memberCount": 5
  }
}
```

### Error Responses

| Status | Code        | Message        |
| ------ | ----------- | -------------- |
| 403    | ERR_BIZ_007 | Group full     |
| 409    | ERR_BIZ_013 | Already member |

---

## API-607: GET /groups/:id/members

### Response

```typescript
interface GroupMembersResponse {
  data: GroupMember[];
}

interface GroupMember {
  id: string;
  user: {
    id: string;
    username: string;
    level: string;
    weeklyXp: number;
  };
  role: "owner" | "admin" | "member";
  joinedAt: string;
}
```

---

← [Subscription APIs](./subscription-apis.md) | _次: [WebSocket APIs](./websocket-apis.md)_
