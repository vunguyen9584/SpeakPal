/**
 * Client to Server Events
 */
export interface ClientEvents {
  // Connection
  connection: (data: { token: string; conversationId: string }) => void;

  // Audio streaming
  audio_stream: (data: AudioStreamData) => void;

  // Control
  interrupt: (data: { reason: string }) => void;
  disconnect: () => void;
}

export interface AudioStreamData {
  chunk: string; // Base64 encoded audio
  sequence: number;
  sampleRate: number;
  channels: number;
  isFinal: boolean;
}
