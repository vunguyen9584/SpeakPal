# WP-INT-004: App Store IAP Integration

## Overview

| Item           | Value                                     |
| -------------- | ----------------------------------------- |
| ID             | WP-INT-004                                |
| Name           | App Store IAP Integration                 |
| Description    | iOS In-App Purchase receipt verification  |
| Dependencies   | WP-BE-015 (Subscription Module)           |
| Estimated Days | 2                                         |
| Total Tasks    | 6                                         |
| DD References  | `03-system-overview.md#external-services` |

---

## Tasks

### Task 1: Create IAP Module

- **ID**: WP-INT-004-T001
- **Type**: setup
- **Description**: Tạo App Store IAP module
- **Files to Create**:
  - `backend/src/integrations/appstore/appstore.module.ts`
  - `backend/src/integrations/appstore/appstore.service.ts`
  - `backend/src/integrations/appstore/interfaces/receipt.interface.ts`
- **Acceptance Criteria**:
  - [ ] Module exports AppStoreService
  - [ ] Shared secret configuration
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Configure App Store Connect

- **ID**: WP-INT-004-T002
- **Type**: feature
- **Description**: Setup App Store Connect credentials
- **Configuration**:
  ```typescript
  const config = {
    sharedSecret: process.env.APPLE_SHARED_SECRET,
    bundleId: "com.speakpal.app",
    productIds: {
      premium_monthly: "com.speakpal.premium.monthly",
      premium_yearly: "com.speakpal.premium.yearly",
    },
    environment:
      process.env.NODE_ENV === "production" ? "production" : "sandbox",
  };
  ```
- **Acceptance Criteria**:
  - [ ] Shared secret from environment
  - [ ] Product IDs configured
  - [ ] Sandbox vs production environment
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 3: Implement Receipt Verification

- **ID**: WP-INT-004-T003
- **Type**: feature
- **Description**: Verify App Store receipts với Apple servers
- **Files to Modify**:
  - `backend/src/integrations/appstore/appstore.service.ts`
- **Implementation**:
  ```typescript
  async verifyReceipt(receiptData: string): Promise<VerificationResult> {
    // Try production first
    let response = await this.verifyWithApple(receiptData, 'production');

    // If sandbox receipt in production, retry sandbox
    if (response.status === 21007) {
      response = await this.verifyWithApple(receiptData, 'sandbox');
    }

    if (response.status !== 0) {
      throw new ReceiptVerificationError(response.status);
    }

    return this.parseReceipt(response.receipt);
  }
  ```
- **Acceptance Criteria**:
  - [ ] Call Apple verifyReceipt API
  - [ ] Handle sandbox/production switch
  - [ ] Parse latest_receipt_info
  - [ ] Return subscription details
- **Estimated Hours**: 4
- **DD Reference**: N/A

---

### Task 4: Implement Subscription Status Check

- **ID**: WP-INT-004-T004
- **Type**: feature
- **Description**: Check subscription expiry và renewal status
- **Files to Modify**:
  - `backend/src/integrations/appstore/appstore.service.ts`
- **Status Fields**:
  - expires_date
  - auto_renew_status
  - is_trial_period
  - cancellation_date
- **Acceptance Criteria**:
  - [ ] Return current subscription status
  - [ ] Check if expired
  - [ ] Check auto-renewal status
  - [ ] Handle trial periods
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 5: Handle Server Notifications

- **ID**: WP-INT-004-T005
- **Type**: feature
- **Description**: Process App Store Server Notifications (webhooks)
- **Files to Create**:
  - `backend/src/integrations/appstore/appstore.webhook.controller.ts`
- **Notification Types**:
  | Type | Action |
  | --------------------- | --------------------------- |
  | INITIAL_BUY | Activate subscription |
  | DID_RENEW | Extend expiry |
  | DID_CHANGE_RENEWAL | Update auto-renew status |
  | CANCEL | Mark as cancelled |
  | DID_FAIL_TO_RENEW | Handle payment failure |
  | REFUND | Revoke subscription |
- **Acceptance Criteria**:
  - [ ] Webhook endpoint with signature verification
  - [ ] Handle all notification types
  - [ ] Update user subscription status
  - [ ] Idempotent processing
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 6: Add Integration Tests

- **ID**: WP-INT-004-T006
- **Type**: test
- **Description**: Integration tests cho App Store service
- **Files to Create**:
  - `backend/src/integrations/appstore/tests/appstore.service.spec.ts`
- **Test Cases**:
  - Receipt verification (mock Apple API)
  - Subscription status parsing
  - Webhook processing
- **Acceptance Criteria**:
  - [ ] Mock Apple API responses
  - [ ] Test all notification types
  - [ ] Test error scenarios
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

## Task Summary

| Task ID         | Name                 | Type    | Hours  | Status |
| --------------- | -------------------- | ------- | ------ | ------ |
| WP-INT-004-T001 | Create Module        | setup   | 1      | ⬜     |
| WP-INT-004-T002 | Configure App Store  | feature | 1      | ⬜     |
| WP-INT-004-T003 | Receipt Verification | feature | 4      | ⬜     |
| WP-INT-004-T004 | Subscription Status  | feature | 2      | ⬜     |
| WP-INT-004-T005 | Server Notifications | feature | 2      | ⬜     |
| WP-INT-004-T006 | Integration Tests    | test    | 2      | ⬜     |
| **Total**       |                      |         | **12** |        |

---

_Back to: [\_phase-6.md](./_phase-6.md)_
