import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/**
 * Current User Decorator
 *
 * Extracts the current authenticated user from the request object.
 * The user is typically attached to the request by authentication middleware/guard.
 *
 * @example
 * ```typescript
 * @Get('profile')
 * getProfile(@CurrentUser() user: User) {
 *   return user;
 * }
 * ```
 *
 * @example
 * ```typescript
 * // Extract specific property
 * @Get('me')
 * getMe(@CurrentUser('id') userId: string) {
 *   return { userId };
 * }
 * ```
 */
export const CurrentUser = createParamDecorator(
  (data: string | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest<Record<string, any>>();
    const user = request.user as Record<string, any> | undefined;

    // If no specific property requested, return entire user object
    if (!data) {
      return user as unknown;
    }

    // Return specific property of user object
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return user?.[data];
  },
);
