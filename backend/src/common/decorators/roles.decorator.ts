import { SetMetadata } from '@nestjs/common';

/**
 * Metadata key for roles
 */
export const ROLES_KEY = 'roles';

/**
 * User roles enum
 *
 * Define user roles for authorization.
 * This can be extended based on application needs.
 */
export enum UserRole {
  USER = 'USER',
  ADMIN = 'ADMIN',
  MODERATOR = 'MODERATOR',
}

/**
 * Roles Decorator
 *
 * Marks a route as requiring specific roles for access.
 * Used in conjunction with a RolesGuard to implement role-based access control.
 *
 * @param roles - Array of roles that are allowed to access the route
 *
 * @example
 * ```typescript
 * @Get('admin')
 * @Roles(UserRole.ADMIN)
 * getAdminData() {
 *   return { message: 'Admin only data' };
 * }
 * ```
 *
 * @example
 * ```typescript
 * @Delete('users/:id')
 * @Roles(UserRole.ADMIN, UserRole.MODERATOR)
 * deleteUser(@Param('id') id: string) {
 *   return this.usersService.delete(id);
 * }
 * ```
 */
export const Roles = (...roles: UserRole[]) => SetMetadata(ROLES_KEY, roles);
