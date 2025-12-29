# Phase 5: Social & Subscription

## Overview

| Item          | Value                 |
| ------------- | --------------------- |
| Phase         | 5                     |
| Description   | Social & Subscription |
| Work Packages | 5                     |
| Total Tasks   | 32                    |
| Est. Days     | 14                    |
| Dependencies  | Phase 1, Phase 4      |

---

## Work Packages

| ID        | Name                      | Tasks | Est. Hours |
| --------- | ------------------------- | ----- | ---------- |
| WP-BE-014 | Social Module (BE)        | 6     | 24         |
| WP-BE-015 | Subscription Module (BE)  | 7     | 32         |
| WP-BE-016 | Notification Module (BE)  | 5     | 16         |
| WP-FE-013 | Social Screens (FE)       | 6     | 24         |
| WP-FE-014 | Subscription Screens (FE) | 5     | 16         |

---

## WP-BE-014: Social Module (BE)

### Overview

- **Description**: Invitations, groups, rankings
- **Dependencies**: WP-BE-012
- **Estimated Days**: 3
- **DD References**: `05-module-design.md#social`, `08-api-design/social-apis.md`

### Tasks

1. **WP-BE-014-T001**: Create Module Structure

   - Type: setup
   - Hours: 1

2. **WP-BE-014-T002**: Create Social DTOs

   - Type: feature
   - Files: invitation.dto.ts, group.dto.ts, group-member.dto.ts
   - Hours: 1.5

3. **WP-BE-014-T003**: Implement Invitation Service

   - Type: feature
   - Features: Generate invite code, accept invitation, track referrals
   - Hours: 4

4. **WP-BE-014-T004**: Implement Group Service

   - Type: feature
   - Features: Create group, join/leave, list members, group rankings
   - Hours: 4

5. **WP-BE-014-T005**: Implement Social Controller

   - Type: feature
   - APIs: /invitations/_, /groups/_
   - Hours: 2

6. **WP-BE-014-T006**: Add Unit Tests
   - Type: test
   - Hours: 2

---

## WP-BE-015: Subscription Module (BE)

### Overview

- **Description**: Plans, usage limits, IAP integration
- **Dependencies**: WP-BE-005
- **Estimated Days**: 4
- **DD References**: `05-module-design.md#subscription`, `08-api-design/subscription-apis.md`

### Tasks

1. **WP-BE-015-T001**: Create Module Structure

   - Type: setup
   - Hours: 1

2. **WP-BE-015-T002**: Create Subscription DTOs

   - Type: feature
   - Hours: 1.5

3. **WP-BE-015-T003**: Implement Plan Service

   - Type: feature
   - Features: Check current plan, usage limits, feature access
   - Hours: 3

4. **WP-BE-015-T004**: Implement Usage Tracking

   - Type: feature
   - Features: Daily conversation count, reset at midnight
   - Hours: 3

5. **WP-BE-015-T005**: Implement Purchase Verification

   - Type: integration
   - Features: Verify App Store/Play Store receipts
   - Hours: 6

6. **WP-BE-015-T006**: Implement Subscription Controller

   - Type: feature
   - APIs: /subscriptions/me, /subscriptions/purchase, /subscriptions/restore
   - Hours: 2

7. **WP-BE-015-T007**: Add Unit Tests
   - Type: test
   - Hours: 2

---

## WP-BE-016: Notification Module (BE)

### Overview

- **Description**: Push notifications, reminders
- **Dependencies**: WP-BE-005
- **Estimated Days**: 2
- **DD References**: `05-module-design.md#notification`

### Tasks

1. **WP-BE-016-T001**: Create Module Structure

   - Type: setup
   - Hours: 1

2. **WP-BE-016-T002**: Integrate Firebase Cloud Messaging

   - Type: integration
   - Hours: 3

3. **WP-BE-016-T003**: Implement Notification Service

   - Type: feature
   - Features: Send push, schedule reminders, notification templates
   - Hours: 4

4. **WP-BE-016-T004**: Implement Daily Reminder Scheduler

   - Type: feature
   - Features: BullMQ job for daily practice reminders
   - Hours: 3

5. **WP-BE-016-T005**: Add Unit Tests
   - Type: test
   - Hours: 2

---

## WP-FE-013: Social Screens (FE)

### Overview

- **Description**: Invite friends, groups, leaderboard
- **Dependencies**: WP-FE-011
- **Estimated Days**: 3
- **DD References**: `09-ui-specifications.md#social`

### Tasks

1. **WP-FE-013-T001**: Create Social Feature Structure

   - Type: setup
   - Hours: 0.5

2. **WP-FE-013-T002**: Implement Invite Friends Screen

   - Type: feature
   - Features: Generate code, share link, show referral rewards
   - Hours: 4

3. **WP-FE-013-T003**: Implement Groups Screen

   - Type: feature
   - Features: List groups, create group, join with code
   - Hours: 4

4. **WP-FE-013-T004**: Implement Group Detail Screen

   - Type: feature
   - Features: Member list, group leaderboard, leave group
   - Hours: 4

5. **WP-FE-013-T005**: Implement Leaderboard Screen

   - Type: feature
   - Features: Weekly rankings, filter by friends/global
   - Hours: 3

6. **WP-FE-013-T006**: Create Social Providers
   - Type: feature
   - Hours: 2

---

## WP-FE-014: Subscription Screens (FE)

### Overview

- **Description**: Plans, upgrade, manage subscription
- **Dependencies**: WP-FE-006
- **Estimated Days**: 2
- **DD References**: `09-ui-specifications.md#subscription`

### Tasks

1. **WP-FE-014-T001**: Create Subscription Feature Structure

   - Type: setup
   - Hours: 0.5

2. **WP-FE-014-T002**: Implement Plans Comparison Screen

   - Type: feature
   - Features: Free vs Premium comparison, feature list
   - Hours: 4

3. **WP-FE-014-T003**: Integrate In-App Purchase

   - Type: integration
   - Features: RevenueCat/in_app_purchase package
   - Hours: 6

4. **WP-FE-014-T004**: Implement Purchase Flow

   - Type: feature
   - Features: Purchase, restore, error handling
   - Hours: 3

5. **WP-FE-014-T005**: Implement Subscription Status Widget
   - Type: feature
   - Features: Show current plan, usage remaining, upgrade CTA
   - Hours: 2

---

## Phase Summary

| Work Package | Name                 | Tasks  | Est. Hours | Status |
| ------------ | -------------------- | ------ | ---------- | ------ |
| WP-BE-014    | Social Module        | 6      | 14.5       | ⬜     |
| WP-BE-015    | Subscription Module  | 7      | 18.5       | ⬜     |
| WP-BE-016    | Notification Module  | 5      | 13         | ⬜     |
| WP-FE-013    | Social Screens       | 6      | 17.5       | ⬜     |
| WP-FE-014    | Subscription Screens | 5      | 15.5       | ⬜     |
| **Total**    |                      | **29** | **79**     |        |

---

## DD References

- `05-module-design.md#social`
- `05-module-design.md#subscription`
- `05-module-design.md#notification`
- `07-database-design/social-tables.md`
- `08-api-design/social-apis.md`
- `08-api-design/subscription-apis.md`
- `09-ui-specifications.md#social`
- `09-ui-specifications.md#subscription`

---

## Next Phase

→ [Phase 6: External Integration](./phase-6-integration/)

---

_Back to: [\_index.md](./_index.md)_
