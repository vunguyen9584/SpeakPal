/**
 * Error Code Constants
 *
 * All error codes used throughout the application.
 * Format: ERR_<CATEGORY>_<NUMBER>
 */

// ============================================================================
// Authentication Errors (ERR_AUTH_*)
// ============================================================================

export const AUTH_ERROR_CODES = {
  INVALID_CREDENTIALS: 'ERR_AUTH_001',
  TOKEN_EXPIRED: 'ERR_AUTH_002',
  TOKEN_INVALID: 'ERR_AUTH_003',
  ACCOUNT_LOCKED: 'ERR_AUTH_004',
  EMAIL_NOT_VERIFIED: 'ERR_AUTH_005',
  INSUFFICIENT_PERMISSIONS: 'ERR_AUTH_006',
  OAUTH_PROVIDER_ERROR: 'ERR_AUTH_007',
} as const;

// ============================================================================
// Validation Errors (ERR_VAL_*)
// ============================================================================

export const VALIDATION_ERROR_CODES = {
  REQUIRED_FIELD_MISSING: 'ERR_VAL_001',
  INVALID_FORMAT: 'ERR_VAL_002',
  VALUE_TOO_SHORT: 'ERR_VAL_003',
  VALUE_TOO_LONG: 'ERR_VAL_004',
  INVALID_ENUM_VALUE: 'ERR_VAL_005',
  INVALID_UUID_FORMAT: 'ERR_VAL_006',
} as const;

// ============================================================================
// Business Logic Errors (ERR_BIZ_*)
// ============================================================================

export const BUSINESS_ERROR_CODES = {
  EMAIL_ALREADY_EXISTS: 'ERR_BIZ_001',
  USAGE_LIMIT_REACHED: 'ERR_BIZ_002',
  PREMIUM_REQUIRED: 'ERR_BIZ_003',
  MAX_PERSONAS_REACHED: 'ERR_BIZ_004',
  STREAK_FREEZE_UNAVAILABLE: 'ERR_BIZ_005',
  INVITATION_ALREADY_USED: 'ERR_BIZ_006',
  GROUP_FULL: 'ERR_BIZ_007',
} as const;

// ============================================================================
// Resource Errors (ERR_RES_*)
// ============================================================================

export const RESOURCE_ERROR_CODES = {
  NOT_FOUND: 'ERR_RES_001',
  USER_NOT_FOUND: 'ERR_RES_002',
  CONVERSATION_NOT_FOUND: 'ERR_RES_003',
  PERSONA_NOT_FOUND: 'ERR_RES_004',
  SCENARIO_NOT_FOUND: 'ERR_RES_005',
} as const;

// ============================================================================
// Rate Limit Errors (ERR_RATE_*)
// ============================================================================

export const RATE_LIMIT_ERROR_CODES = {
  TOO_MANY_REQUESTS: 'ERR_RATE_001',
  DAILY_LIMIT_EXCEEDED: 'ERR_RATE_002',
} as const;

// ============================================================================
// External Service Errors (ERR_EXT_*)
// ============================================================================

export const EXTERNAL_ERROR_CODES = {
  STT_SERVICE_UNAVAILABLE: 'ERR_EXT_001',
  LLM_SERVICE_UNAVAILABLE: 'ERR_EXT_002',
  TTS_SERVICE_UNAVAILABLE: 'ERR_EXT_003',
  PAYMENT_SERVICE_ERROR: 'ERR_EXT_004',
} as const;

// ============================================================================
// Internal Errors (ERR_INT_*)
// ============================================================================

export const INTERNAL_ERROR_CODES = {
  UNEXPECTED_ERROR: 'ERR_INT_001',
  DATABASE_ERROR: 'ERR_INT_002',
  CONFIGURATION_ERROR: 'ERR_INT_003',
} as const;

// ============================================================================
// Combined Error Codes
// ============================================================================

export const ERROR_CODES = {
  AUTH: AUTH_ERROR_CODES,
  VALIDATION: VALIDATION_ERROR_CODES,
  BUSINESS: BUSINESS_ERROR_CODES,
  RESOURCE: RESOURCE_ERROR_CODES,
  RATE_LIMIT: RATE_LIMIT_ERROR_CODES,
  EXTERNAL: EXTERNAL_ERROR_CODES,
  INTERNAL: INTERNAL_ERROR_CODES,
} as const;
