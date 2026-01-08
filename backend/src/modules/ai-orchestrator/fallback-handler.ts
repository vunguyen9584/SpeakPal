import { Injectable, Logger } from '@nestjs/common';

export enum ServiceType {
  STT = 'STT',
  LLM = 'LLM',
  TTS = 'TTS',
}

export interface FallbackStrategy {
  service: ServiceType;
  action: 'retry' | 'fallback' | 'skip' | 'error';
  message: string;
}

@Injectable()
export class FallbackHandler {
  private readonly logger = new Logger(FallbackHandler.name);
  private readonly circuitBreakers: Map<ServiceType, CircuitBreaker> =
    new Map();
  private readonly MAX_RETRIES = 2;
  private readonly RETRY_DELAY_MS = 1000;

  constructor() {
    // Initialize circuit breakers for each service
    Object.values(ServiceType).forEach((service) => {
      this.circuitBreakers.set(service, new CircuitBreaker());
    });
  }

  /**
   * Handle STT service error
   * @param error Error object
   * @returns Fallback strategy
   */
  handleSTTError(error: Error): FallbackStrategy {
    this.logger.error(`STT Error: ${error.message}`, error.stack);

    const breaker = this.circuitBreakers.get(ServiceType.STT);
    if (breaker && breaker.isOpen()) {
      return {
        service: ServiceType.STT,
        action: 'error',
        message:
          'STT service is currently unavailable. Please try again later.',
      };
    }

    breaker?.recordFailure();

    return {
      service: ServiceType.STT,
      action: 'error',
      message:
        'Failed to transcribe audio. Please check your microphone and try again.',
    };
  }

  /**
   * Handle LLM service error
   * @param error Error object
   * @param context Context for fallback response
   * @returns Fallback strategy with possible fallback response
   */
  handleLLMError(error: Error, context?: any): FallbackStrategy {
    this.logger.error(`LLM Error: ${error.message}`, error.stack);

    const breaker = this.circuitBreakers.get(ServiceType.LLM);
    if (breaker && breaker.isOpen()) {
      // Use simple fallback responses when circuit is open
      return {
        service: ServiceType.LLM,
        action: 'fallback',
        message: this.getFallbackResponse(),
      };
    }

    breaker?.recordFailure();

    // Check if it's a timeout
    if (error.message.includes('timeout')) {
      return {
        service: ServiceType.LLM,
        action: 'retry',
        message: 'LLM request timed out. Retrying with shorter prompt...',
      };
    }

    // For other errors, use fallback response
    return {
      service: ServiceType.LLM,
      action: 'fallback',
      message: this.getFallbackResponse(),
    };
  }

  /**
   * Handle TTS service error
   * @param error Error object
   * @param text Text that failed to synthesize
   * @returns Fallback strategy
   */
  handleTTSError(error: Error, text: string): FallbackStrategy {
    this.logger.error(`TTS Error: ${error.message}`, error.stack);

    const breaker = this.circuitBreakers.get(ServiceType.TTS);
    if (breaker && breaker.isOpen()) {
      // Fall back to text-only mode
      return {
        service: ServiceType.TTS,
        action: 'fallback',
        message: `Text-only mode: ${text}`,
      };
    }

    breaker?.recordFailure();

    // Always fall back to text-only for TTS failures
    return {
      service: ServiceType.TTS,
      action: 'fallback',
      message: `Audio unavailable. Text response: ${text}`,
    };
  }

  /**
   * Retry a failed operation with exponential backoff
   * @param operation Operation to retry
   * @param retries Number of retries attempted
   * @returns Result of operation
   */
  async retryWithBackoff<T>(
    operation: () => Promise<T>,
    retries = 0,
  ): Promise<T> {
    try {
      return await operation();
    } catch (error) {
      if (retries >= this.MAX_RETRIES) {
        throw error;
      }

      const delay = this.RETRY_DELAY_MS * Math.pow(2, retries);
      this.logger.warn(`Retry attempt ${retries + 1} after ${delay}ms`);

      await this.sleep(delay);
      return this.retryWithBackoff(operation, retries + 1);
    }
  }

  /**
   * Get a simple fallback response when LLM fails
   * @private
   */
  private getFallbackResponse(): string {
    const fallbackResponses = [
      "I'm having trouble processing that right now. Could you try again?",
      "Please continue. I'm listening.",
      "That's interesting. Tell me more.",
      'I see. Can you elaborate on that?',
    ];

    return fallbackResponses[
      Math.floor(Math.random() * fallbackResponses.length)
    ];
  }

  /**
   * Record successful operation (for circuit breaker)
   * @param service Service type
   */
  recordSuccess(service: ServiceType): void {
    const breaker = this.circuitBreakers.get(service);
    breaker?.recordSuccess();
  }

  /**
   * Check if service is available
   * @param service Service type
   * @returns True if service is available
   */
  isServiceAvailable(service: ServiceType): boolean {
    const breaker = this.circuitBreakers.get(service);
    return !breaker?.isOpen();
  }

  /**
   * Reset circuit breaker for a service
   * @param service Service type
   */
  resetCircuitBreaker(service: ServiceType): void {
    const breaker = this.circuitBreakers.get(service);
    breaker?.reset();
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}

/**
 * Simple circuit breaker implementation
 */
class CircuitBreaker {
  private failures = 0;
  private lastFailureTime?: Date;
  private state: 'closed' | 'open' | 'half-open' = 'closed';

  private readonly FAILURE_THRESHOLD = 5;
  private readonly TIMEOUT_MS = 60000; // 1 minute

  recordFailure(): void {
    this.failures++;
    this.lastFailureTime = new Date();

    if (this.failures >= this.FAILURE_THRESHOLD) {
      this.state = 'open';
    }
  }

  recordSuccess(): void {
    this.failures = 0;
    this.state = 'closed';
    this.lastFailureTime = undefined;
  }

  isOpen(): boolean {
    if (this.state === 'open' && this.lastFailureTime) {
      const elapsedMs = Date.now() - this.lastFailureTime.getTime();
      if (elapsedMs > this.TIMEOUT_MS) {
        // Try half-open state
        this.state = 'half-open';
        return false;
      }
      return true;
    }
    return false;
  }

  reset(): void {
    this.failures = 0;
    this.state = 'closed';
    this.lastFailureTime = undefined;
  }
}
