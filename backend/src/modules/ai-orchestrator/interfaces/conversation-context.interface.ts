import { ConversationMode } from '@prisma/client';

export interface ConversationContext {
  conversationId: string;
  userId: string;
  mode: ConversationMode;
  userLevel: string;
  personaId?: string;
  topic?: string;
  previousTurns?: ConversationTurn[];
}

export interface ConversationTurn {
  speaker: 'user' | 'ai';
  content: string;
  timestamp: Date;
}
