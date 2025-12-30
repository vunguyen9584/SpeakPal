import { Conversation as PrismaConversation } from '@prisma/client';

export type ConversationEntity = PrismaConversation;

// Re-export for convenience
export { ConversationMode, ConversationStatus } from '@prisma/client';
