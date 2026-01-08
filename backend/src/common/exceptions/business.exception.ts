import { HttpStatus } from '@nestjs/common';
import { AppException } from './app.exception';
import {
  BUSINESS_ERROR_CODES,
  RESOURCE_ERROR_CODES,
  RATE_LIMIT_ERROR_CODES,
  EXTERNAL_ERROR_CODES,
  INTERNAL_ERROR_CODES,
} from './error-codes';

/**
 * Base business logic exception
 */
export abstract class BusinessException extends AppException {
  constructor(
    message: string,
    code: string,
    statusCode: HttpStatus = HttpStatus.BAD_REQUEST,
    details?: Record<string, any>,
  ) {
    super(message, code, statusCode, details);
  }
}

// ============================================================================
// Business Logic Exceptions
// ============================================================================

/**
 * Email already exists exception
 */
export class EmailAlreadyExistsException extends BusinessException {
  readonly code = BUSINESS_ERROR_CODES.EMAIL_ALREADY_EXISTS;

  constructor(email: string, details?: Record<string, any>) {
    super(
      'Email already exists',
      BUSINESS_ERROR_CODES.EMAIL_ALREADY_EXISTS,
      HttpStatus.CONFLICT,
      { email, ...details },
    );
  }
}

/**
 * Usage limit reached exception
 */
export class UsageLimitReachedException extends BusinessException {
  readonly code = BUSINESS_ERROR_CODES.USAGE_LIMIT_REACHED;

  constructor(limit: number, details?: Record<string, any>) {
    super(
      `Daily usage limit of ${limit} reached`,
      BUSINESS_ERROR_CODES.USAGE_LIMIT_REACHED,
      HttpStatus.FORBIDDEN,
      { limit, ...details },
    );
  }
}

/**
 * Premium required exception
 */
export class PremiumRequiredException extends BusinessException {
  readonly code = BUSINESS_ERROR_CODES.PREMIUM_REQUIRED;

  constructor(feature: string, details?: Record<string, any>) {
    super(
      `Premium subscription required for feature: ${feature}`,
      BUSINESS_ERROR_CODES.PREMIUM_REQUIRED,
      HttpStatus.FORBIDDEN,
      { feature, ...details },
    );
  }
}

/**
 * Max personas reached exception
 */
export class MaxPersonasReachedException extends BusinessException {
  readonly code = BUSINESS_ERROR_CODES.MAX_PERSONAS_REACHED;

  constructor(maxPersonas: number, details?: Record<string, any>) {
    super(
      `Maximum number of personas (${maxPersonas}) reached`,
      BUSINESS_ERROR_CODES.MAX_PERSONAS_REACHED,
      HttpStatus.BAD_REQUEST,
      { maxPersonas, ...details },
    );
  }
}

/**
 * Streak freeze unavailable exception
 */
export class StreakFreezeUnavailableException extends BusinessException {
  readonly code = BUSINESS_ERROR_CODES.STREAK_FREEZE_UNAVAILABLE;

  constructor(details?: Record<string, any>) {
    super(
      'No streak freeze available',
      BUSINESS_ERROR_CODES.STREAK_FREEZE_UNAVAILABLE,
      HttpStatus.BAD_REQUEST,
      details,
    );
  }
}

/**
 * Invitation already used exception
 */
export class InvitationAlreadyUsedException extends BusinessException {
  readonly code = BUSINESS_ERROR_CODES.INVITATION_ALREADY_USED;

  constructor(invitationCode: string, details?: Record<string, any>) {
    super(
      `Invitation code ${invitationCode} has already been used`,
      BUSINESS_ERROR_CODES.INVITATION_ALREADY_USED,
      HttpStatus.CONFLICT,
      { invitationCode, ...details },
    );
  }
}

/**
 * Group full exception
 */
export class GroupFullException extends BusinessException {
  readonly code = BUSINESS_ERROR_CODES.GROUP_FULL;

  constructor(
    groupId: string,
    maxMembers: number,
    details?: Record<string, any>,
  ) {
    super(
      `Group is full (${maxMembers} members)`,
      BUSINESS_ERROR_CODES.GROUP_FULL,
      HttpStatus.BAD_REQUEST,
      { groupId, maxMembers, ...details },
    );
  }
}

// ============================================================================
// Resource Exceptions
// ============================================================================

/**
 * Resource not found exception
 */
export class ResourceNotFoundException extends BusinessException {
  readonly code = RESOURCE_ERROR_CODES.NOT_FOUND;

  constructor(
    resourceType: string,
    resourceId: string,
    details?: Record<string, any>,
  ) {
    super(
      `${resourceType} not found: ${resourceId}`,
      RESOURCE_ERROR_CODES.NOT_FOUND,
      HttpStatus.NOT_FOUND,
      { resourceType, resourceId, ...details },
    );
  }
}

/**
 * User not found exception
 */
export class UserNotFoundException extends BusinessException {
  readonly code = RESOURCE_ERROR_CODES.USER_NOT_FOUND;

  constructor(userId: string, details?: Record<string, any>) {
    super(
      `User not found: ${userId}`,
      RESOURCE_ERROR_CODES.USER_NOT_FOUND,
      HttpStatus.NOT_FOUND,
      { userId, ...details },
    );
  }
}

/**
 * Conversation not found exception
 */
export class ConversationNotFoundException extends BusinessException {
  readonly code = RESOURCE_ERROR_CODES.CONVERSATION_NOT_FOUND;

  constructor(conversationId: string, details?: Record<string, any>) {
    super(
      `Conversation not found: ${conversationId}`,
      RESOURCE_ERROR_CODES.CONVERSATION_NOT_FOUND,
      HttpStatus.NOT_FOUND,
      { conversationId, ...details },
    );
  }
}

/**
 * Persona not found exception
 */
export class PersonaNotFoundException extends BusinessException {
  readonly code = RESOURCE_ERROR_CODES.PERSONA_NOT_FOUND;

  constructor(personaId: string, details?: Record<string, any>) {
    super(
      `Persona not found: ${personaId}`,
      RESOURCE_ERROR_CODES.PERSONA_NOT_FOUND,
      HttpStatus.NOT_FOUND,
      { personaId, ...details },
    );
  }
}

/**
 * Scenario not found exception
 */
export class ScenarioNotFoundException extends BusinessException {
  readonly code = RESOURCE_ERROR_CODES.SCENARIO_NOT_FOUND;

  constructor(scenarioId: string, details?: Record<string, any>) {
    super(
      `Scenario not found: ${scenarioId}`,
      RESOURCE_ERROR_CODES.SCENARIO_NOT_FOUND,
      HttpStatus.NOT_FOUND,
      { scenarioId, ...details },
    );
  }
}

// ============================================================================
// Rate Limit Exceptions
// ============================================================================

/**
 * Too many requests exception
 */
export class TooManyRequestsException extends BusinessException {
  readonly code = RATE_LIMIT_ERROR_CODES.TOO_MANY_REQUESTS;

  constructor(retryAfter?: number, details?: Record<string, any>) {
    super(
      'Too many requests',
      RATE_LIMIT_ERROR_CODES.TOO_MANY_REQUESTS,
      HttpStatus.TOO_MANY_REQUESTS,
      { retryAfter, ...details },
    );
  }
}

// ============================================================================
// External Service Exceptions
// ============================================================================

/**
 * STT service unavailable exception
 */
export class SttServiceUnavailableException extends BusinessException {
  readonly code = EXTERNAL_ERROR_CODES.STT_SERVICE_UNAVAILABLE;

  constructor(details?: Record<string, any>) {
    super(
      'Speech-to-text service unavailable',
      EXTERNAL_ERROR_CODES.STT_SERVICE_UNAVAILABLE,
      HttpStatus.SERVICE_UNAVAILABLE,
      details,
    );
  }
}

/**
 * LLM service unavailable exception
 */
export class LlmServiceUnavailableException extends BusinessException {
  readonly code = EXTERNAL_ERROR_CODES.LLM_SERVICE_UNAVAILABLE;

  constructor(details?: Record<string, any>) {
    super(
      'LLM service unavailable',
      EXTERNAL_ERROR_CODES.LLM_SERVICE_UNAVAILABLE,
      HttpStatus.SERVICE_UNAVAILABLE,
      details,
    );
  }
}

/**
 * TTS service unavailable exception
 */
export class TtsServiceUnavailableException extends BusinessException {
  readonly code = EXTERNAL_ERROR_CODES.TTS_SERVICE_UNAVAILABLE;

  constructor(details?: Record<string, any>) {
    super(
      'Text-to-speech service unavailable',
      EXTERNAL_ERROR_CODES.TTS_SERVICE_UNAVAILABLE,
      HttpStatus.SERVICE_UNAVAILABLE,
      details,
    );
  }
}

/**
 * Payment service error exception
 */
export class PaymentServiceErrorException extends BusinessException {
  readonly code = EXTERNAL_ERROR_CODES.PAYMENT_SERVICE_ERROR;

  constructor(details?: Record<string, any>) {
    super(
      'Payment service error',
      EXTERNAL_ERROR_CODES.PAYMENT_SERVICE_ERROR,
      HttpStatus.SERVICE_UNAVAILABLE,
      details,
    );
  }
}

// ============================================================================
// Internal Exceptions
// ============================================================================

/**
 * Unexpected error exception
 */
export class UnexpectedErrorException extends BusinessException {
  readonly code = INTERNAL_ERROR_CODES.UNEXPECTED_ERROR;

  constructor(originalError?: Error, details?: Record<string, any>) {
    super(
      'An unexpected error occurred',
      INTERNAL_ERROR_CODES.UNEXPECTED_ERROR,
      HttpStatus.INTERNAL_SERVER_ERROR,
      { originalError: originalError?.message, ...details },
    );
  }
}

/**
 * Database error exception
 */
export class DatabaseErrorException extends BusinessException {
  readonly code = INTERNAL_ERROR_CODES.DATABASE_ERROR;

  constructor(operation: string, details?: Record<string, any>) {
    super(
      `Database error during ${operation}`,
      INTERNAL_ERROR_CODES.DATABASE_ERROR,
      HttpStatus.INTERNAL_SERVER_ERROR,
      { operation, ...details },
    );
  }
}
