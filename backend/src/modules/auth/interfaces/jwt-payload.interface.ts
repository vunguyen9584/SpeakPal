export interface JwtPayload {
  sub: string; // User ID
  email: string;
  iat?: number; // Issued at
  exp?: number; // Expiration time
}

export interface JwtRefreshPayload {
  sub: string; // User ID
  tokenId: string; // Unique token ID for rotation
  iat?: number;
  exp?: number;
}
