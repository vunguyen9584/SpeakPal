-- AlterTable
ALTER TABLE "subscriptions" ADD COLUMN     "auto_renewing" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "order_id" TEXT,
ADD COLUMN     "platform" TEXT,
ADD COLUMN     "status" TEXT NOT NULL DEFAULT 'active';

-- CreateTable
CREATE TABLE "daily_usage" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "type" TEXT NOT NULL,
    "count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "daily_usage_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "daily_usage_user_id_date_idx" ON "daily_usage"("user_id", "date");

-- CreateIndex
CREATE INDEX "daily_usage_date_idx" ON "daily_usage"("date");

-- CreateIndex
CREATE UNIQUE INDEX "daily_usage_user_id_date_type_key" ON "daily_usage"("user_id", "date", "type");

-- CreateIndex
CREATE INDEX "subscriptions_status_idx" ON "subscriptions"("status");
