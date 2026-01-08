import { Injectable } from '@nestjs/common';

export interface StreamState {
  conversationId: string;
  sessionId: string;
  isActive: boolean;
  startedAt: Date;
  bytesProcessed: number;
}

@Injectable()
export class StreamingHandler {
  private activeStreams: Map<string, StreamState> = new Map();
  private abortControllers: Map<string, AbortController> = new Map();
  private readonly HIGH_WATER_MARK = 64 * 1024; // 64KB
  private readonly MAX_STREAMS_PER_USER = 1;

  /**
   * Start a new stream for a session
   * @param sessionId Session ID
   * @param conversationId Conversation ID
   */
  startStream(sessionId: string, conversationId: string): Promise<void> {
    // Check if stream already exists
    if (this.activeStreams.has(sessionId)) {
      throw new Error(`Stream already active for session: ${sessionId}`);
    }

    // Create abort controller for this stream
    const abortController = new AbortController();
    this.abortControllers.set(sessionId, abortController);

    // Register stream state
    this.activeStreams.set(sessionId, {
      conversationId,
      sessionId,
      isActive: true,
      startedAt: new Date(),
      bytesProcessed: 0,
    });

    return Promise.resolve();
  }

  /**
   * Stop streaming for a session
   * @param sessionId Session ID
   */
  stopStream(sessionId: string): Promise<void> {
    // Abort the stream if it exists
    const abortController = this.abortControllers.get(sessionId);
    if (abortController) {
      abortController.abort();
      this.abortControllers.delete(sessionId);
    }

    // Remove stream state
    this.activeStreams.delete(sessionId);
    return Promise.resolve();
  }

  /**
   * Check if a session is currently streaming
   * @param sessionId Session ID
   * @returns True if streaming is active
   */
  isStreaming(sessionId: string): boolean {
    const state = this.activeStreams.get(sessionId);
    return state?.isActive || false;
  }

  /**
   * Get stream state for a session
   * @param sessionId Session ID
   * @returns Stream state or undefined
   */
  getStreamState(sessionId: string): StreamState | undefined {
    return this.activeStreams.get(sessionId);
  }

  /**
   * Update bytes processed for a stream
   * @param sessionId Session ID
   * @param bytes Number of bytes processed
   */
  updateBytesProcessed(sessionId: string, bytes: number): void {
    const state = this.activeStreams.get(sessionId);
    if (state) {
      state.bytesProcessed += bytes;
    }
  }

  /**
   * Wait for drain (backpressure management)
   * @param sessionId Session ID
   */
  async waitForDrain(sessionId: string): Promise<void> {
    const state = this.activeStreams.get(sessionId);
    if (!state) return;

    // If bytes processed exceeds high water mark, wait a bit
    if (state.bytesProcessed > this.HIGH_WATER_MARK) {
      await this.delay(100); // Wait 100ms for drain
      state.bytesProcessed = 0; // Reset counter
    }
  }

  /**
   * Set high water mark for a session
   * @param sessionId Session ID
   * @param mark High water mark in bytes
   */
  setHighWaterMark(_sessionId: string, _mark: number): void {
    // This could be stored per-session if needed
    // For now, using a global HIGH_WATER_MARK
  }

  /**
   * Check concurrent stream limit for a user
   * @param userId User ID
   * @param conversationId Current conversation ID
   * @returns True if user can start a new stream
   */
  canStartStream(userId: string, conversationId: string): boolean {
    let userStreamCount = 0;

    for (const state of this.activeStreams.values()) {
      if (state.conversationId.startsWith(userId)) {
        // Assuming conversationId includes userId
        userStreamCount++;
      }
    }

    return userStreamCount < this.MAX_STREAMS_PER_USER;
  }

  /**
   * Cleanup all streams for a conversation
   * @param conversationId Conversation ID
   */
  async cleanupConversation(conversationId: string): Promise<void> {
    const sessionsToCleanup: string[] = [];

    // Find all sessions for this conversation
    for (const [sessionId, state] of this.activeStreams.entries()) {
      if (state.conversationId === conversationId) {
        sessionsToCleanup.push(sessionId);
      }
    }

    // Stop all sessions
    for (const sessionId of sessionsToCleanup) {
      await this.stopStream(sessionId);
    }
  }

  /**
   * Get all active streams
   * @returns Map of active streams
   */
  getActiveStreams(): Map<string, StreamState> {
    return new Map(this.activeStreams);
  }

  /**
   * Get abort signal for a session
   * @param sessionId Session ID
   * @returns AbortSignal or undefined
   */
  getAbortSignal(sessionId: string): AbortSignal | undefined {
    return this.abortControllers.get(sessionId)?.signal;
  }

  private delay(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
