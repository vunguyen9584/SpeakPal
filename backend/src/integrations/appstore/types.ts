export interface AppStoreConfig {
    sharedSecret: string;
    bundleId: string;
    useSandbox: boolean;
}

export interface ReceiptVerificationRequest {
    receiptData: string;
    excludeOldTransactions?: boolean;
}

export interface ReceiptVerificationResponse {
    status: number;
    receipt: Receipt;
    latest_receipt_info?: LatestReceiptInfo[];
    pending_renewal_info?: PendingRenewalInfo[];
}

export interface Receipt {
    bundle_id: string;
    application_version: string;
    in_app: InAppPurchase[];
}

export interface InAppPurchase {
    product_id: string;
    transaction_id: string;
    original_transaction_id: string;
    purchase_date: string;
    purchase_date_ms: string;
    expires_date?: string;
    expires_date_ms?: string;
    is_trial_period?: string;
    is_in_intro_offer_period?: string;
}

export interface LatestReceiptInfo {
    product_id: string;
    transaction_id: string;
    original_transaction_id: string;
    purchase_date_ms: string;
    expires_date_ms: string;
    is_trial_period: string;
    cancellation_date_ms?: string;
}

export interface PendingRenewalInfo {
    auto_renew_product_id: string;
    auto_renew_status: string;
    expiration_intent?: string;
}

export interface SubscriptionStatus {
    isActive: boolean;
    productId: string;
    expiresAt: Date | null;
    isTrialPeriod: boolean;
    willAutoRenew: boolean;
    cancellationDate: Date | null;
}

export interface ServerNotification {
    notification_type: string;
    password: string;
    environment: string;
    unified_receipt: {
        latest_receipt_info: LatestReceiptInfo[];
        pending_renewal_info: PendingRenewalInfo[];
    };
}
