import { SetMetadata } from '@nestjs/common';

/**
 * Metadata key for public routes
 */
export const IS_PUBLIC_KEY = 'isPublic';

/**
 * Public Decorator
 *
 * Marks a route as public (no authentication required).
 * Used to bypass authentication guards for specific endpoints.
 *
 * By default, routes protected by an authentication guard will require
 * a valid JWT token. Using this decorator allows public access to
 * specific routes without authentication.
 *
 * @example
 * ```typescript
 * @Post('register')
 * @Public()
 * register(@Body() dto: RegisterDto) {
 *   return this.authService.register(dto);
 * }
 * ```
 *
 * @example
 * ```typescript
 * @Get('health')
 * @Public()
 * healthCheck() {
 *   return { status: 'ok' };
 * }
 * ```
 */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
