import { Voice, Personality, Level } from '@prisma/client';

export class PersonaDto {
  id: string;
  userId: string;
  name: string;
  voice: Voice;
  personality: Personality;
  targetLevel: Level;
  isDefault: boolean;
  createdAt: Date;
}
