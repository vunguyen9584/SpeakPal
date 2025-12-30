import { Level, League } from '@prisma/client';

export class UserDto {
  id: string;
  email: string;
  username: string;
  level: Level;
  totalXp: number;
  currentLevelXp: number;
  nextLevelXp: number;
  league: League;
  aiSpeed: number;
  confirmationMode: boolean;
  isVerified: boolean;
  createdAt: Date;
}
