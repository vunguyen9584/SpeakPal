import { Injectable, Logger } from '@nestjs/common';

export interface RateLimitConfig {
  eventsPerSecond: number;
  dataBytesPerSecond: number;
  maxConcurrentSessions: number;
  maxDailyAudioMinutes: { free: number; premium: number };
}

const DEFAULT_CONFIG: RateLimitConfig = {
  eventsPerSecond: 10,
  dataBytesPerSecond: 64 * 1024, // 64KB/s
  maxConcurrentSessions: 1,
  maxDailyAudioMinutes: { free: 30, premium: Number.MAX_SAFE_INTEGER },
};

@Injectable()
export class WsRateLimiter {
  private readonly logger = new Logger(WsRateLimiter.name);
  private readonly config: RateLimitConfig = DEFAULT_CONFIG;

  // Event rate tracking
  private eventCounts: Map<string, number> = new Map();
  private eventTimestamps: Map<string, number> = new Map();

  // Data rate tracking
  private dataSizes: Map<string, number> = new Map();
  private dataTimestamps: Map<string, number> = new Map();

  // Session tracking
  private activeSessions: Map<string, Set<string>> = new Map(); // userId -> Set<sessionId>

  // Daily audio tracking
  private dailyAudioMinutes: Map<string, number> = new Map(); // userId -> minutes

  /**
   * Check if client can send event
   * @param clientId Client/Socket ID
   * @returns True if allowed, false if rate limited
   */
  checkEventLimit(clientId: string): boolean {
    const now = Date.now();
    const lastTimestamp = this.eventTimestamps.get(clientId) || 0;

    // Reset counter if more than 1 second passed
    if (now - lastTimestamp > 1000) {
      this.eventCounts.set(clientId, 0);
      this.eventTimestamps.set(clientId, now);
    }

    const currentCount = this.eventCounts.get(clientId) || 0;

    if (currentCount >= this.config.eventsPerSecond) {
      this.logger.warn(`Rate limit exceeded for events: ${clientId}`);
      return false;
    }

    this.eventCounts.set(clientId, currentCount + 1);
    return true;
  }

  /**
   * Check if client can send data of given size
   * @param clientId Client/Socket ID
   * @param size Data size in bytes
   * @returns True if allowed, false if rate limited
   */
  checkDataLimit(clientId: string, size: number): boolean {
    const now = Date.now();
    const lastTimestamp = this.dataTimestamps.get(clientId) || 0;

    // Reset counter if more than 1 second passed
    if (now - lastTimestamp > 1000) {
      this.dataSizes.set(clientId, 0);
      this.dataTimestamps.set(clientId, now);
    }

    const currentSize = this.dataSizes.get(clientId) || 0;

    if (currentSize + size > this.config.dataBytesPerSecond) {
      this.logger.warn(`Rate limit exceeded for data: ${clientId}`);
      return false;
    }

    this.dataSizes.set(clientId, currentSize + size);
    return true;
  }

  /**
   * Check concurrent session limit for user
   * @param userId User ID
   * @param clientId Client/Socket ID
   * @returns True if allowed, false if limit exceeded
   */
  checkConcurrentLimit(userId: string, clientId: string): boolean {
    const sessions = this.activeSessions.get(userId) || new Set();

    // If this client already has a session, allow it
    if (sessions.has(clientId)) {
      return true;
    }

    // Check limit
    if (sessions.size >= this.config.maxConcurrentSessions) {
      this.logger.warn(
        `Concurrent session limit exceeded for user: ${userId}`,
      );
      return false;
    }

    // Add session
    sessions.add(clientId);
    this.activeSessions.set(userId, sessions);
    return true;
  }

  /**
   * Check daily audio usage limit
   * @param userId User ID
   * @param duration Duration in minutes
   * @param userPlan User subscription plan
   * @returns True if allowed, false if limit exceeded
   */
  checkDailyAudioLimit(
    userId: string,
    duration: number,
    userPlan: 'free' | 'premium' = 'free',
  ): boolean {
    const currentMinutes = this.dailyAudioMinutes.get(userId) || 0;
    const limit = this.config.maxDailyAudioMinutes[userPlan];

    if (currentMinutes + duration > limit) {
      this.logger.warn(`Daily audio limit exceeded for user: ${userId}`);
      return false;
    }

    this.dailyAudioMinutes.set(userId, currentMinutes + duration);
    return true;
  }

  /**
   * Remove session from tracking
   * @param userId User ID
   * @param clientId Client/Socket ID
   */
  removeSession(userId: string, clientId: string): void {
    const sessions = this.activeSessions.get(userId);
    if (sessions) {
      sessions.delete(clientId);
      if (sessions.size === 0) {
        this.activeSessions.delete(userId);
      }
    }
  }

  /**
   * Reset counters for a client
   * @param clientId Client/Socket ID
   */
  reset(clientId: string): void {
    this.eventCounts.delete(clientId);
    this.eventTimestamps.delete(clientId);
    this.dataSizes.delete(clientId);
    this.dataTimestamps.delete(clientId);
  }

  /**
   * Reset daily audio tracking (should be called daily)
   */
  resetDailyAudio(): void {
    this.dailyAudioMinutes.clear();
  }

  /**
   * Get remaining quota for user
   * @param userId User ID
   * @param userPlan User subscription plan
   * @returns Remaining audio minutes
   */
  getRemainingAudioMinutes(
    userId: string,
    userPlan: 'free' | 'premium' = 'free',
  ): number {
    const used = this.dailyAudioMinutes.get(userId) || 0;
    const limit = this.config.maxDailyAudioMinutes[userPlan];
    return Math.max(0, limit - used);
  }
}
