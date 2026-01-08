import { ConversationTurn as PrismaTurn } from '@prisma/client';

export type TurnEntity = PrismaTurn;

// Re-export for convenience
export { Speaker } from '@prisma/client';
