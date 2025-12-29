# WP-INT-005: Play Store IAP Integration

## Overview

| Item           | Value                                     |
| -------------- | ----------------------------------------- |
| ID             | WP-INT-005                                |
| Name           | Play Store IAP Integration                |
| Description    | Android In-App Purchase verification      |
| Dependencies   | WP-BE-015 (Subscription Module)           |
| Estimated Days | 2                                         |
| Total Tasks    | 6                                         |
| DD References  | `03-system-overview.md#external-services` |

---

## Tasks

### Task 1: Create Play Store Module

- **ID**: WP-INT-005-T001
- **Type**: setup
- **Description**: Tạo Play Store integration module
- **Files to Create**:
  - `backend/src/integrations/playstore/playstore.module.ts`
  - `backend/src/integrations/playstore/playstore.service.ts`
  - `backend/src/integrations/playstore/interfaces/purchase.interface.ts`
- **Acceptance Criteria**:
  - [ ] Module exports PlayStoreService
  - [ ] Google API client configuration
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Configure Google Play Console

- **ID**: WP-INT-005-T002
- **Type**: feature
- **Description**: Setup Google Cloud service account
- **Configuration**:

  ```typescript
  const config = {
    serviceAccountKey: JSON.parse(process.env.GOOGLE_SERVICE_ACCOUNT),
    packageName: "com.speakpal.app",
    productIds: {
      premium_monthly: "premium_monthly",
      premium_yearly: "premium_yearly",
    },
  };

  // Initialize Google API client
  const auth = new google.auth.GoogleAuth({
    credentials: config.serviceAccountKey,
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  ```

- **Acceptance Criteria**:
  - [ ] Service account from environment
  - [ ] Package name configured
  - [ ] Product IDs configured
  - [ ] Google API auth setup
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 3: Implement Purchase Verification

- **ID**: WP-INT-005-T003
- **Type**: feature
- **Description**: Verify purchases với Google Play Developer API
- **Files to Modify**:
  - `backend/src/integrations/playstore/playstore.service.ts`
- **Implementation**:
  ```typescript
  async verifyPurchase(productId: string, purchaseToken: string): Promise<VerificationResult> {
    const androidPublisher = google.androidpublisher('v3');

    const response = await androidPublisher.purchases.subscriptions.get({
      auth: this.auth,
      packageName: this.packageName,
      subscriptionId: productId,
      token: purchaseToken,
    });

    return {
      isValid: response.data.paymentState === 1,
      expiryTime: new Date(parseInt(response.data.expiryTimeMillis)),
      autoRenewing: response.data.autoRenewing,
      orderId: response.data.orderId,
    };
  }
  ```
- **Acceptance Criteria**:
  - [ ] Call Google Play Developer API
  - [ ] Parse subscription details
  - [ ] Handle invalid tokens
  - [ ] Return verification result
- **Estimated Hours**: 4
- **DD Reference**: N/A

---

### Task 4: Implement Subscription Status Check

- **ID**: WP-INT-005-T004
- **Type**: feature
- **Description**: Check subscription status và renewal
- **Files to Modify**:
  - `backend/src/integrations/playstore/playstore.service.ts`
- **Status Fields**:
  - expiryTimeMillis
  - autoRenewing
  - paymentState
  - cancelReason
  - userCancellationTimeMillis
- **Acceptance Criteria**:
  - [ ] Return current subscription status
  - [ ] Check if expired
  - [ ] Check auto-renewal status
  - [ ] Handle cancellation
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 5: Handle RTDN (Real-time Developer Notifications)

- **ID**: WP-INT-005-T005
- **Type**: feature
- **Description**: Process Google Cloud Pub/Sub notifications
- **Files to Create**:
  - `backend/src/integrations/playstore/playstore.webhook.controller.ts`
- **Notification Types**:
  | Type | Action |
  | --------------------------- | --------------------------- |
  | SUBSCRIPTION_PURCHASED | Activate subscription |
  | SUBSCRIPTION_RENEWED | Extend expiry |
  | SUBSCRIPTION_CANCELED | Update status |
  | SUBSCRIPTION_ON_HOLD | Handle payment issue |
  | SUBSCRIPTION_IN_GRACE_PERIOD| Grace period handling |
  | SUBSCRIPTION_REVOKED | Revoke access |
- **Acceptance Criteria**:
  - [ ] Pub/Sub webhook endpoint
  - [ ] Handle all notification types
  - [ ] Update user subscription
  - [ ] Idempotent processing
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 6: Add Integration Tests

- **ID**: WP-INT-005-T006
- **Type**: test
- **Description**: Integration tests cho Play Store service
- **Files to Create**:
  - `backend/src/integrations/playstore/tests/playstore.service.spec.ts`
- **Test Cases**:
  - Purchase verification (mock Google API)
  - Subscription status parsing
  - RTDN processing
- **Acceptance Criteria**:
  - [ ] Mock Google API responses
  - [ ] Test all notification types
  - [ ] Test error scenarios
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

## Task Summary

| Task ID         | Name                   | Type    | Hours  | Status |
| --------------- | ---------------------- | ------- | ------ | ------ |
| WP-INT-005-T001 | Create Module          | setup   | 1      | ⬜     |
| WP-INT-005-T002 | Configure Play Console | feature | 1      | ⬜     |
| WP-INT-005-T003 | Purchase Verification  | feature | 4      | ⬜     |
| WP-INT-005-T004 | Subscription Status    | feature | 2      | ⬜     |
| WP-INT-005-T005 | Handle RTDN            | feature | 2      | ⬜     |
| WP-INT-005-T006 | Integration Tests      | test    | 2      | ⬜     |
| **Total**       |                        |         | **12** |        |

---

_Back to: [\_phase-6.md](./_phase-6.md)_
