export interface PlayStoreConfig {
  packageName: string;
  serviceAccountEmail: string;
  serviceAccountKey: string;
}

export interface PurchaseVerificationRequest {
  packageName: string;
  productId: string;
  purchaseToken: string;
}

export interface SubscriptionPurchase {
  kind: string;
  startTimeMillis: string;
  expiryTimeMillis: string;
  autoRenewing: boolean;
  priceCurrencyCode: string;
  priceAmountMicros: string;
  countryCode: string;
  developerPayload: string;
  cancelReason?: number;
  userCancellationTimeMillis?: string;
  orderId: string;
  linkedPurchaseToken?: string;
  purchaseType?: number;
  acknowledgementState: number;
}

export interface ProductPurchase {
  kind: string;
  purchaseTimeMillis: string;
  purchaseState: number;
  consumptionState: number;
  developerPayload: string;
  orderId: string;
  purchaseType?: number;
  acknowledgementState: number;
  purchaseToken: string;
}

export interface PlayStoreSubscriptionStatus {
  isActive: boolean;
  productId: string;
  expiresAt: Date;
  willAutoRenew: boolean;
  cancelReason: string | null;
  isAcknowledged: boolean;
}

export interface RTDNMessage {
  version: string;
  packageName: string;
  eventTimeMillis: string;
  subscriptionNotification?: SubscriptionNotification;
  oneTimeProductNotification?: OneTimeProductNotification;
}

export interface SubscriptionNotification {
  version: string;
  notificationType: number;
  purchaseToken: string;
  subscriptionId: string;
}

export interface OneTimeProductNotification {
  version: string;
  notificationType: number;
  purchaseToken: string;
  sku: string;
}
