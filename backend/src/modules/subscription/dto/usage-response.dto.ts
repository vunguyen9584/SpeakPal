export class UsageResponseDto {
    dailyConversationsUsed: number;
    dailyConversationsLimit: number;
    resetAt: Date; // Midnight UTC
    canStartConversation: boolean;

    static create(used: number, limit: number): UsageResponseDto {
        const dto = new UsageResponseDto();
        dto.dailyConversationsUsed = used;
        dto.dailyConversationsLimit = limit;
        dto.canStartConversation = limit === -1 || used < limit;

        // Calculate next reset time (midnight UTC)
        const now = new Date();
        const resetAt = new Date(Date.UTC(
            now.getUTCFullYear(),
            now.getUTCMonth(),
            now.getUTCDate() + 1,
            0, 0, 0, 0
        ));
        dto.resetAt = resetAt;

        return dto;
    }
}
