import { applyDecorators, Type } from '@nestjs/common';
import { ApiExtraModels, ApiOkResponse, getSchemaPath } from '@nestjs/swagger';
import { PaginatedResponseDto } from '../dto/pagination.dto';

/**
 * API Paginated Response Decorator
 *
 * Swagger decorator for paginated responses.
 * Automatically generates proper OpenAPI documentation for paginated endpoints.
 *
 * @param dataDto - The DTO class for individual items in the paginated response
 *
 * @example
 * ```typescript
 * @Get('users')
 * @ApiPaginatedResponse(UserDto)
 * async getUsers(@Query() query: PaginationQueryDto) {
 *   const users = await this.usersService.findAll(query);
 *   return new PaginatedResponseDto(
 *     users,
 *     query.page,
 *     query.limit,
 *     totalCount
 *   );
 * }
 * ```
 */
export const ApiPaginatedResponse = <TModel extends Type<unknown>>(
  dataDto: TModel,
) => {
  return applyDecorators(
    ApiExtraModels(PaginatedResponseDto, dataDto),
    ApiOkResponse({
      description: 'Paginated response',
      schema: {
        allOf: [
          {
            properties: {
              success: {
                type: 'boolean',
                example: true,
              },
              data: {
                type: 'array',
                items: { $ref: getSchemaPath(dataDto) },
              },
              pagination: {
                type: 'object',
                properties: {
                  page: {
                    type: 'number',
                    example: 1,
                  },
                  limit: {
                    type: 'number',
                    example: 20,
                  },
                  total: {
                    type: 'number',
                    example: 100,
                  },
                  totalPages: {
                    type: 'number',
                    example: 5,
                  },
                  hasNext: {
                    type: 'boolean',
                    example: true,
                  },
                  hasPrev: {
                    type: 'boolean',
                    example: false,
                  },
                },
              },
            },
          },
        ],
      },
    }),
  );
};
