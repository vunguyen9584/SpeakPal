import { registerAs } from '@nestjs/config';

/**
 * External Services Configuration
 * Centralized URL management for all external service integrations
 */
export default registerAs('externalServices', () => ({
  // OpenAI API
  openai: {
    baseUrl:
      process.env.OPENAI_API_URL ||
      'https://api.openai.com/v1/chat/completions',
    apiKey: process.env.OPENAI_API_KEY || '',
  },

  // Apple App Store
  appStore: {
    productionUrl:
      process.env.APPSTORE_PRODUCTION_URL ||
      'https://buy.itunes.apple.com/verifyReceipt',
    sandboxUrl:
      process.env.APPSTORE_SANDBOX_URL ||
      'https://sandbox.itunes.apple.com/verifyReceipt',
    sharedSecret: process.env.APPSTORE_SHARED_SECRET || '',
    bundleId: process.env.APPSTORE_BUNDLE_ID || '',
    useSandbox: process.env.APPSTORE_USE_SANDBOX === 'true',
  },

  // Google Play Store
  playStore: {
    authScope:
      process.env.PLAYSTORE_AUTH_SCOPE ||
      'https://www.googleapis.com/auth/androidpublisher',
    packageName: process.env.PLAYSTORE_PACKAGE_NAME || '',
    serviceAccountEmail: process.env.PLAYSTORE_SERVICE_ACCOUNT_EMAIL || '',
    serviceAccountKey: process.env.PLAYSTORE_SERVICE_ACCOUNT_KEY || '',
  },

  // Application URLs
  app: {
    baseUrl: process.env.APP_URL || 'https://speakpal.app',
    corsOrigins: process.env.CORS_ORIGINS?.split(',') || [
      'http://localhost:3000',
    ],
  },
}));
