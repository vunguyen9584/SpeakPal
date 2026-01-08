# Phase 6: Social & Subscription

**Status**: 🎉 **100% COMPLETE** (2026-01-08)  
**Progress**: 29/29 tasks ✅  
**Documentation**: `docs/implementation-plan/phase-5-social/`

---

## Overview

| Item          | Value                 |
| ------------- | --------------------- |
| Phase         | 6                     |
| Description   | Social & Subscription |
| Work Packages | 5                     |
| Total Tasks   | 29                    |
| Completed     | 29 ✅                 |
| Est. Hours    | 79                    |
| Actual Hours  | ~5                    |
| Est. Days     | ~10 days (8h/day)     |
| Actual Days   | 1 day                 |
| Dependencies  | Phase 1, Phase 4      |

---

## WP-BE-014: Social Module (BE)

### Overview

| Item            | Value                                                        |
| --------------- | ------------------------------------------------------------ |
| ID              | WP-BE-014                                                    |
| Description     | Invitations, groups, referral system                         |
| Dependencies    | WP-BE-012 (Gamification)                                     |
| Estimated Hours | 14.5                                                         |
| Total Tasks     | 6                                                            |
| DD References   | `05-module-design.md#social`, `08-api-design/social-apis.md` |

### Tasks

#### Task 1: Create Module Structure

- **ID**: WP-BE-014-T001
- **Type**: setup
- **Description**: Khởi tạo Social module với services
- **Commands**:
  ```bash
  nest g module modules/social
  nest g controller modules/social/invitation
  nest g controller modules/social/group
  nest g service modules/social/invitation
  nest g service modules/social/group
  ```
- **Files to Create**:
  - `backend/src/modules/social/social.module.ts`
  - `backend/src/modules/social/invitation/invitation.controller.ts`
  - `backend/src/modules/social/invitation/invitation.service.ts`
  - `backend/src/modules/social/group/group.controller.ts`
  - `backend/src/modules/social/group/group.service.ts`
- **Acceptance Criteria**:
  - [ ] Module registered trong AppModule
  - [ ] Controllers và Services injected
- **Estimated Hours**: 1

---

#### Task 2: Create Social DTOs

- **ID**: WP-BE-014-T002
- **Type**: feature
- **Description**: Tạo DTOs cho Social APIs
- **Files to Create**:
  - `backend/src/modules/social/invitation/dto/create-invitation.dto.ts`
  - `backend/src/modules/social/invitation/dto/invitation-response.dto.ts`
  - `backend/src/modules/social/group/dto/create-group.dto.ts`
  - `backend/src/modules/social/group/dto/group-response.dto.ts`
  - `backend/src/modules/social/group/dto/group-member.dto.ts`
- **DTO Examples**:

  ```typescript
  export class CreateGroupDto {
    @IsString()
    @Length(3, 50)
    name: string;

    @IsOptional()
    @IsString()
    @MaxLength(200)
    description?: string;

    @IsOptional()
    @IsBoolean()
    isPublic?: boolean = true;
  }

  export class InvitationResponseDto {
    id: string;
    inviteCode: string;
    inviteUrl: string;
    usageCount: number;
    maxUsage: number;
    expiresAt: Date;
  }
  ```

- **Acceptance Criteria**:
  - [ ] CreateGroupDto với validation
  - [ ] InvitationResponseDto với invite URL
  - [ ] GroupMemberDto với role
- **Estimated Hours**: 1.5

---

#### Task 3: Implement Invitation Service

- **ID**: WP-BE-014-T003
- **Type**: feature
- **Description**: Generate invite codes, track referrals, award bonuses
- **Files to Create**:
  - `backend/src/modules/social/invitation/invitation.repository.ts`
- **Files to Modify**:
  - `backend/src/modules/social/invitation/invitation.service.ts`
- **Implementation**:

  ```typescript
  @Injectable()
  export class InvitationService {
    async generateInviteCode(userId: string): Promise<Invitation> {
      const code = this.generateUniqueCode(8);
      return this.repo.create({
        userId,
        code,
        maxUsage: 10,
        expiresAt: addDays(new Date(), 30),
      });
    }

    async acceptInvitation(code: string, newUserId: string): Promise<void> {
      const invitation = await this.repo.findByCode(code);
      if (!invitation || invitation.usageCount >= invitation.maxUsage) {
        throw new BadRequestException("Invalid or expired invitation");
      }

      // Record referral
      await this.repo.recordReferral(invitation.id, newUserId);

      // Award bonus to inviter (streak freeze)
      await this.rewardService.awardReferralBonus(invitation.userId);
    }
  }
  ```

- **Referral Rewards**:
  | Referrals | Reward |
  | --------- | ------------------------- |
  | 1 | 1 streak freeze |
  | 5 | 100 bonus XP |
  | 10 | 1 week premium trial |
- **Acceptance Criteria**:
  - [ ] Generate unique 8-char invite codes
  - [ ] Track usage count
  - [ ] Award referral bonuses
  - [ ] Handle expiration
- **Estimated Hours**: 4

---

#### Task 4: Implement Group Service

- **ID**: WP-BE-014-T004
- **Type**: feature
- **Description**: Create groups, manage members, group rankings
- **Files to Create**:
  - `backend/src/modules/social/group/group.repository.ts`
- **Files to Modify**:
  - `backend/src/modules/social/group/group.service.ts`
- **Implementation**:

  ```typescript
  @Injectable()
  export class GroupService {
    async createGroup(userId: string, dto: CreateGroupDto): Promise<Group> {
      const group = await this.repo.create({
        ...dto,
        ownerId: userId,
        inviteCode: this.generateInviteCode(),
      });

      // Add creator as admin member
      await this.addMember(group.id, userId, "admin");
      return group;
    }

    async joinGroup(code: string, userId: string): Promise<void> {
      const group = await this.repo.findByInviteCode(code);
      if (!group) throw new NotFoundException("Group not found");

      await this.addMember(group.id, userId, "member");
    }

    async getGroupRanking(groupId: string): Promise<RankingEntry[]> {
      return this.repo.getMembersByWeeklyXP(groupId);
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Create group với owner
  - [ ] Join group via invite code
  - [ ] Leave group
  - [ ] List members với roles
  - [ ] Group weekly rankings
- **Estimated Hours**: 4

---

#### Task 5: Implement Social Controller

- **ID**: WP-BE-014-T005
- **Type**: feature
- **Description**: REST API endpoints cho Social
- **Files to Modify**:
  - `backend/src/modules/social/invitation/invitation.controller.ts`
  - `backend/src/modules/social/group/group.controller.ts`
- **APIs**:
  | Method | Endpoint | Description |
  | ------ | ---------------------- | --------------------- |
  | POST | /invitations | Generate invite code |
  | GET | /invitations/mine | Get my invitations |
  | POST | /invitations/accept | Accept invitation |
  | POST | /groups | Create group |
  | GET | /groups | List my groups |
  | POST | /groups/join | Join group with code |
  | GET | /groups/:id | Get group details |
  | GET | /groups/:id/members | List members |
  | GET | /groups/:id/ranking | Group rankings |
  | DELETE | /groups/:id/leave | Leave group |
- **Acceptance Criteria**:
  - [ ] All 10 endpoints implemented
  - [ ] JWT authentication
  - [ ] Proper error responses
- **Estimated Hours**: 2

---

#### Task 6: Add Unit Tests

- **ID**: WP-BE-014-T006
- **Type**: test
- **Description**: Unit tests cho Social module
- **Files to Create**:
  - `backend/src/modules/social/tests/invitation.service.spec.ts`
  - `backend/src/modules/social/tests/group.service.spec.ts`
- **Test Cases**:
  - Invite code generation và uniqueness
  - Referral tracking và rewards
  - Group creation và membership
- **Acceptance Criteria**:
  - [ ] Coverage >= 80%
  - [ ] Test referral bonus logic
- **Estimated Hours**: 2

---

## WP-BE-015: Subscription Module (BE)

### Overview

| Item            | Value                                                                    |
| --------------- | ------------------------------------------------------------------------ |
| ID              | WP-BE-015                                                                |
| Description     | Plans, usage limits, subscription management                             |
| Dependencies    | WP-BE-005 (User Module)                                                  |
| Estimated Hours | 18.5                                                                     |
| Total Tasks     | 7                                                                        |
| DD References   | `05-module-design.md#subscription`, `08-api-design/subscription-apis.md` |

### Tasks

#### Task 1: Create Module Structure

- **ID**: WP-BE-015-T001
- **Type**: setup
- **Description**: Khởi tạo Subscription module
- **Commands**:
  ```bash
  nest g module modules/subscription
  nest g controller modules/subscription
  nest g service modules/subscription/plan
  nest g service modules/subscription/usage
  nest g service modules/subscription/purchase
  ```
- **Files to Create**:
  - `backend/src/modules/subscription/subscription.module.ts`
  - `backend/src/modules/subscription/subscription.controller.ts`
  - `backend/src/modules/subscription/plan.service.ts`
  - `backend/src/modules/subscription/usage.service.ts`
  - `backend/src/modules/subscription/purchase.service.ts`
- **Estimated Hours**: 1

---

#### Task 2: Create Subscription DTOs

- **ID**: WP-BE-015-T002
- **Type**: feature
- **Description**: Tạo DTOs cho Subscription APIs
- **Files to Create**:
  - `backend/src/modules/subscription/dto/subscription-response.dto.ts`
  - `backend/src/modules/subscription/dto/purchase-request.dto.ts`
  - `backend/src/modules/subscription/dto/usage-response.dto.ts`
- **DTO Examples**:

  ```typescript
  export class SubscriptionResponseDto {
    plan: "free" | "premium";
    status: "active" | "expired" | "cancelled";
    expiresAt: Date | null;
    features: {
      dailyConversations: number;
      unlimitedVocabulary: boolean;
      prioritySupport: boolean;
      noAds: boolean;
    };
  }

  export class UsageResponseDto {
    dailyConversationsUsed: number;
    dailyConversationsLimit: number;
    resetAt: Date; // Midnight UTC
  }
  ```

- **Estimated Hours**: 1.5

---

#### Task 3: Implement Plan Service

- **ID**: WP-BE-015-T003
- **Type**: feature
- **Description**: Check current plan, feature access
- **Files to Modify**:
  - `backend/src/modules/subscription/plan.service.ts`
- **Plan Features**:
  | Feature | Free | Premium |
  | -------------------- | ------ | --------- |
  | Daily Conversations | 3 | Unlimited |
  | Vocabulary Save | 50 | Unlimited |
  | AI Personas | 1 | All |
  | Ads | Yes | No |
  | Priority Support | No | Yes |
- **Implementation**:

  ```typescript
  @Injectable()
  export class PlanService {
    async getCurrentPlan(userId: string): Promise<SubscriptionPlan> {
      const sub = await this.repo.findByUserId(userId);
      if (!sub || sub.expiresAt < new Date()) {
        return this.getFreePlan();
      }
      return sub.plan;
    }

    async checkFeatureAccess(
      userId: string,
      feature: string
    ): Promise<boolean> {
      const plan = await this.getCurrentPlan(userId);
      return PLAN_FEATURES[plan][feature] ?? false;
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Get current plan với expiry check
  - [ ] Check feature access
  - [ ] Return plan features
- **Estimated Hours**: 3

---

#### Task 4: Implement Usage Tracking

- **ID**: WP-BE-015-T004
- **Type**: feature
- **Description**: Track daily usage, enforce limits
- **Files to Modify**:
  - `backend/src/modules/subscription/usage.service.ts`
- **Implementation**:

  ```typescript
  @Injectable()
  export class UsageService {
    async checkAndIncrementUsage(
      userId: string,
      type: UsageType
    ): Promise<boolean> {
      const plan = await this.planService.getCurrentPlan(userId);
      const limit = PLAN_LIMITS[plan][type];

      if (limit === -1) return true; // Unlimited

      const today = startOfDay(new Date());
      const usage = await this.repo.getUsage(userId, type, today);

      if (usage >= limit) {
        throw new ForbiddenException("Daily limit reached");
      }

      await this.repo.incrementUsage(userId, type, today);
      return true;
    }

    async getUsageStatus(userId: string): Promise<UsageStatus> {
      // Return current usage vs limits
    }
  }
  ```

- **Reset Logic**: Daily at midnight UTC via cron job
- **Acceptance Criteria**:
  - [ ] Track daily conversations
  - [ ] Enforce limits based on plan
  - [ ] Reset at midnight UTC
  - [ ] Return usage status
- **Estimated Hours**: 3

---

#### Task 5: Implement Purchase Verification

- **ID**: WP-BE-015-T005
- **Type**: integration
- **Description**: Verify IAP receipts từ App Store/Play Store
- **Files to Modify**:
  - `backend/src/modules/subscription/purchase.service.ts`
- **Implementation**:

  ```typescript
  @Injectable()
  export class PurchaseService {
    constructor(
      private appStoreService: AppStoreService,
      private playStoreService: PlayStoreService
    ) {}

    async verifyPurchase(dto: PurchaseDto): Promise<VerificationResult> {
      if (dto.platform === "ios") {
        return this.appStoreService.verifyReceipt(dto.receipt);
      } else {
        return this.playStoreService.verifyPurchase(dto.productId, dto.token);
      }
    }

    async activateSubscription(
      userId: string,
      result: VerificationResult
    ): Promise<void> {
      await this.subscriptionRepo.upsert({
        userId,
        plan: "premium",
        expiresAt: result.expiryTime,
        autoRenewing: result.autoRenewing,
        orderId: result.orderId,
        platform: result.platform,
      });
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Verify iOS receipts
  - [ ] Verify Android purchases
  - [ ] Activate subscription on success
  - [ ] Handle upgrade/downgrade
- **Estimated Hours**: 6

---

#### Task 6: Implement Subscription Controller

- **ID**: WP-BE-015-T006
- **Type**: feature
- **Description**: REST API endpoints
- **APIs**:
  | Method | Endpoint | Description |
  | ------ | ---------------------- | ----------------------- |
  | GET | /subscriptions/me | Get current subscription|
  | GET | /subscriptions/usage | Get usage status |
  | POST | /subscriptions/purchase| Verify and activate |
  | POST | /subscriptions/restore | Restore purchases |
- **Acceptance Criteria**:
  - [ ] All 4 endpoints implemented
  - [ ] Handle platform differences
- **Estimated Hours**: 2

---

#### Task 7: Add Unit Tests

- **ID**: WP-BE-015-T007
- **Type**: test
- **Description**: Unit tests cho Subscription module
- **Test Cases**:
  - Plan feature checks
  - Usage tracking và limits
  - Purchase verification (mocked)
- **Acceptance Criteria**:
  - [ ] Coverage >= 80%
- **Estimated Hours**: 2

---

## WP-BE-016: Notification Module (BE)

### Overview

| Item            | Value                              |
| --------------- | ---------------------------------- |
| ID              | WP-BE-016                          |
| Description     | Push notifications, reminders      |
| Dependencies    | WP-BE-005 (User Module)            |
| Estimated Hours | 13                                 |
| Total Tasks     | 5                                  |
| DD References   | `05-module-design.md#notification` |

### Tasks

#### Task 1: Create Module Structure

- **ID**: WP-BE-016-T001
- **Type**: setup
- **Description**: Khởi tạo Notification module
- **Commands**:
  ```bash
  nest g module modules/notification
  nest g service modules/notification
  ```
- **Files to Create**:
  - `backend/src/modules/notification/notification.module.ts`
  - `backend/src/modules/notification/notification.service.ts`
  - `backend/src/modules/notification/notification.types.ts`
- **Estimated Hours**: 1

---

#### Task 2: Integrate Firebase Cloud Messaging

- **ID**: WP-BE-016-T002
- **Type**: integration
- **Description**: Setup FCM cho push notifications
- **Commands**:
  ```bash
  npm install firebase-admin
  ```
- **Files to Create**:
  - `backend/src/integrations/firebase/firebase.module.ts`
  - `backend/src/integrations/firebase/fcm.service.ts`
- **Implementation**:

  ```typescript
  @Injectable()
  export class FCMService {
    private app: admin.app.App;

    constructor() {
      this.app = admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          privateKey: process.env.FIREBASE_PRIVATE_KEY,
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        }),
      });
    }

    async sendPush(
      token: string,
      notification: FCMNotification
    ): Promise<void> {
      await this.app.messaging().send({
        token,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: notification.data,
      });
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] FCM initialized với service account
  - [ ] Send single push notification
  - [ ] Send batch notifications
- **Estimated Hours**: 3

---

#### Task 3: Implement Notification Service

- **ID**: WP-BE-016-T003
- **Type**: feature
- **Description**: High-level notification service với templates
- **Files to Modify**:
  - `backend/src/modules/notification/notification.service.ts`
- **Files to Create**:
  - `backend/src/modules/notification/templates/notification.templates.ts`
- **Notification Types**:
  | Type | Template |
  | ------------------ | ------------------------------------- |
  | streak_reminder | "Don't forget to practice today!" |
  | streak_at_risk | "Your streak is at risk!" |
  | badge_earned | "Congratulations! You earned {badge}" |
  | level_up | "You reached level {level}!" |
  | weekly_report | "Your weekly report is ready" |
- **Acceptance Criteria**:
  - [ ] Template-based notifications
  - [ ] Store notification history
  - [ ] Mark as read functionality
  - [ ] Notification preferences
- **Estimated Hours**: 4

---

#### Task 4: Implement Daily Reminder Scheduler

- **ID**: WP-BE-016-T004
- **Type**: feature
- **Description**: Scheduled job cho daily practice reminders
- **Commands**:
  ```bash
  npm install @nestjs/schedule
  npm install @nestjs/bull bull
  ```
- **Files to Create**:
  - `backend/src/modules/notification/notification.scheduler.ts`
- **Implementation**:

  ```typescript
  @Injectable()
  export class NotificationScheduler {
    // Run at 19:00 UTC daily
    @Cron("0 19 * * *")
    async sendDailyReminders() {
      const usersWithoutActivity =
        await this.userRepo.findWithoutActivityToday();

      for (const user of usersWithoutActivity) {
        if (user.notificationSettings.dailyReminder) {
          await this.notificationService.send(user.id, "streak_reminder");
        }
      }
    }

    // Run at 23:00 UTC for at-risk streaks
    @Cron("0 23 * * *")
    async sendStreakAtRiskReminders() {
      const atRiskUsers = await this.streakRepo.findAtRisk();
      // Send urgent reminder
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Daily reminder at 19:00 UTC
  - [ ] Streak at-risk at 23:00 UTC
  - [ ] Respect user notification preferences
  - [ ] BullMQ queue for reliability
- **Estimated Hours**: 3

---

#### Task 5: Add Unit Tests

- **ID**: WP-BE-016-T005
- **Type**: test
- **Description**: Unit tests cho Notification module
- **Test Cases**:
  - Template rendering
  - Notification preferences
  - Scheduler logic
- **Acceptance Criteria**:
  - [ ] Coverage >= 80%
  - [ ] Mock FCM calls
- **Estimated Hours**: 2

---

## WP-FE-013: Social Screens (FE)

### Overview

| Item            | Value                               |
| --------------- | ----------------------------------- |
| ID              | WP-FE-013                           |
| Description     | Invite friends, groups, leaderboard |
| Dependencies    | WP-FE-011 (Gamification)            |
| Estimated Hours | 17.5                                |
| Total Tasks     | 6                                   |
| DD References   | `09-ui-specifications.md#social`    |

### Tasks

#### Task 1: Create Social Feature Structure

- **ID**: WP-FE-013-T001
- **Type**: setup
- **Description**: Tạo feature structure cho Social
- **Commands**:
  ```bash
  mkdir -p lib/features/social/{data,domain,presentation}/{models,repositories,providers,screens,widgets}
  ```
- **Files to Create**:
  - `mobile/lib/features/social/social_feature.dart`
  - `mobile/lib/features/social/domain/models/invitation.dart`
  - `mobile/lib/features/social/domain/models/group.dart`
  - `mobile/lib/features/social/domain/repositories/social_repository.dart`
- **Estimated Hours**: 0.5

---

#### Task 2: Implement Invite Friends Screen

- **ID**: WP-FE-013-T002
- **Type**: feature
- **Description**: Generate và share invite codes
- **Files to Create**:
  - `mobile/lib/features/social/presentation/screens/invite_screen.dart`
  - `mobile/lib/features/social/presentation/widgets/invite_code_card.dart`
- **Features**:
  - Display unique invite code
  - Copy to clipboard button
  - Share via native share sheet
  - Referral rewards display
  - Referral history (who accepted)
- **Dependencies**:
  ```yaml
  dependencies:
    share_plus: ^7.0.0
  ```
- **Acceptance Criteria**:
  - [ ] Display invite code prominently
  - [ ] Share button works on iOS/Android
  - [ ] Show referral rewards earned
  - [ ] Show pending referrals
- **Estimated Hours**: 4

---

#### Task 3: Implement Groups Screen

- **ID**: WP-FE-013-T003
- **Type**: feature
- **Description**: List groups và create/join
- **Files to Create**:
  - `mobile/lib/features/social/presentation/screens/groups_screen.dart`
  - `mobile/lib/features/social/presentation/widgets/group_list_item.dart`
  - `mobile/lib/features/social/presentation/screens/create_group_screen.dart`
- **Features**:
  - List my groups với member count
  - Create new group button
  - Join group với invite code
  - Search public groups
- **Acceptance Criteria**:
  - [ ] List all groups user belongs to
  - [ ] Create group với name/description
  - [ ] Join via invite code dialog
- **Estimated Hours**: 4

---

#### Task 4: Implement Group Detail Screen

- **ID**: WP-FE-013-T004
- **Type**: feature
- **Description**: Group info, members, rankings
- **Files to Create**:
  - `mobile/lib/features/social/presentation/screens/group_detail_screen.dart`
  - `mobile/lib/features/social/presentation/widgets/member_list_item.dart`
- **Features**:
  - Group info header
  - Member list với XP
  - Group weekly ranking
  - Invite code share
  - Leave group button
- **Acceptance Criteria**:
  - [ ] Show all members với roles
  - [ ] Weekly ranking by XP
  - [ ] Share invite code
  - [ ] Leave group với confirmation
- **Estimated Hours**: 4

---

#### Task 5: Implement Friends Leaderboard

- **ID**: WP-FE-013-T005
- **Type**: feature
- **Description**: Weekly rankings filtered by friends
- **Files to Modify**:
  - Extend `mobile/lib/features/gamification/presentation/screens/leaderboard_screen.dart`
- **Features**:
  - Tab: Global / Friends / Group
  - Friends: People who accepted your invite
  - Highlight your position
- **Acceptance Criteria**:
  - [ ] Friends tab working
  - [ ] Show friends' weekly XP
  - [ ] Your rank highlighted
- **Estimated Hours**: 3

---

#### Task 6: Create Social Providers

- **ID**: WP-FE-013-T006
- **Type**: feature
- **Description**: Riverpod providers cho Social
- **Files to Create**:
  - `mobile/lib/features/social/presentation/providers/social_providers.dart`
- **Providers**:
  ```dart
  final invitationProvider = FutureProvider.autoDispose<Invitation>();
  final myGroupsProvider = FutureProvider.autoDispose<List<Group>>();
  final groupDetailProvider = FutureProvider.autoDispose.family<Group, String>();
  final groupRankingProvider = FutureProvider.autoDispose.family<List<RankingEntry>, String>();
  final friendsRankingProvider = FutureProvider.autoDispose<List<RankingEntry>>();
  ```
- **Acceptance Criteria**:
  - [ ] All providers implemented
  - [ ] Cache invalidation on actions
- **Estimated Hours**: 2

---

## WP-FE-014: Subscription Screens (FE)

### Overview

| Item            | Value                                  |
| --------------- | -------------------------------------- |
| ID              | WP-FE-014                              |
| Description     | Plans comparison, upgrade, manage      |
| Dependencies    | WP-FE-006 (Profile)                    |
| Estimated Hours | 15.5                                   |
| Total Tasks     | 5                                      |
| DD References   | `09-ui-specifications.md#subscription` |

### Tasks

#### Task 1: Create Subscription Feature Structure

- **ID**: WP-FE-014-T001
- **Type**: setup
- **Description**: Tạo feature structure
- **Files to Create**:
  - `mobile/lib/features/subscription/subscription_feature.dart`
  - `mobile/lib/features/subscription/domain/models/subscription.dart`
  - `mobile/lib/features/subscription/domain/models/plan.dart`
- **Estimated Hours**: 0.5

---

#### Task 2: Implement Plans Comparison Screen

- **ID**: WP-FE-014-T002
- **Type**: feature
- **Description**: Compare Free vs Premium plans
- **Files to Create**:
  - `mobile/lib/features/subscription/presentation/screens/plans_screen.dart`
  - `mobile/lib/features/subscription/presentation/widgets/plan_card.dart`
  - `mobile/lib/features/subscription/presentation/widgets/feature_compare_row.dart`
- **Features**:
  - Side-by-side plan comparison
  - Feature checklist (✓/✗)
  - Price display (monthly/yearly)
  - Current plan indicator
  - Select plan button
- **Acceptance Criteria**:
  - [ ] Clear Free vs Premium comparison
  - [ ] Monthly and yearly pricing
  - [ ] Discount for yearly
  - [ ] Highlighting current plan
- **Estimated Hours**: 4

---

#### Task 3: Integrate In-App Purchase

- **ID**: WP-FE-014-T003
- **Type**: integration
- **Description**: Setup in_app_purchase hoặc RevenueCat
- **Dependencies**:
  ```yaml
  dependencies:
    purchases_flutter: ^6.0.0 # RevenueCat SDK
  ```
- **Files to Create**:
  - `mobile/lib/core/services/purchase_service.dart`
- **Implementation**:

  ```dart
  class PurchaseService {
    Future<void> initialize() async {
      await Purchases.setLogLevel(LogLevel.debug);
      await Purchases.configure(
        PurchasesConfiguration(Platform.isIOS
          ? 'appl_revenueCatApiKey'
          : 'goog_revenueCatApiKey'),
      );
    }

    Future<List<Package>> getPackages() async {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    }

    Future<CustomerInfo> purchase(Package package) async {
      return await Purchases.purchasePackage(package);
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] RevenueCat SDK integrated
  - [ ] Fetch available packages
  - [ ] Handle purchase flow
  - [ ] Restore purchases
- **Estimated Hours**: 6

---

#### Task 4: Implement Purchase Flow

- **ID**: WP-FE-014-T004
- **Type**: feature
- **Description**: Purchase, loading, success/error states
- **Files to Create**:
  - `mobile/lib/features/subscription/presentation/screens/purchase_screen.dart`
  - `mobile/lib/features/subscription/presentation/widgets/purchase_button.dart`
- **Flow**:
  1. User selects plan
  2. Show native payment sheet
  3. Loading state
  4. Success → Update UI, show confirmation
  5. Error → Show error message
- **Acceptance Criteria**:
  - [ ] Native payment sheet
  - [ ] Loading indicator
  - [ ] Success celebration
  - [ ] Error handling
  - [ ] Receipt sent to backend
- **Estimated Hours**: 3

---

#### Task 5: Implement Subscription Status Widget

- **ID**: WP-FE-014-T005
- **Type**: feature
- **Description**: Widget showing current plan và usage
- **Files to Create**:
  - `mobile/lib/features/subscription/presentation/widgets/subscription_status_widget.dart`
- **Features**:
  - Current plan badge (Free/Premium)
  - Usage bar (3/3 conversations today)
  - Upgrade CTA for free users
  - Expiry date for premium users
- **Placement**: Profile screen, Home screen
- **Acceptance Criteria**:
  - [ ] Show current plan
  - [ ] Show daily usage
  - [ ] Upgrade button for free
  - [ ] Manage button for premium
- **Estimated Hours**: 2

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
