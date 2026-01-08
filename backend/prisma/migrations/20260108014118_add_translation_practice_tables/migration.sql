-- CreateEnum
CREATE TYPE "PracticeType" AS ENUM ('DIRECT', 'INTENT', 'WORD_ASSOCIATION', 'INSTANT_DRILL', 'SHADOWING');

-- CreateEnum
CREATE TYPE "ContentType" AS ENUM ('CONVERSATION', 'NEWS', 'SPEECH', 'PODCAST');

-- CreateTable
CREATE TABLE "translation_questions" (
    "id" TEXT NOT NULL,
    "topic" VARCHAR(50) NOT NULL,
    "level" "Level" NOT NULL,
    "source_language" VARCHAR(5) NOT NULL DEFAULT 'ja',
    "source_text" TEXT NOT NULL,
    "target_text" TEXT NOT NULL,
    "alt_answers" JSONB,
    "difficulty" INTEGER NOT NULL DEFAULT 3,
    "word_count" INTEGER NOT NULL,
    "grammar_points" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "translation_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "translation_results" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "practice_type" "PracticeType" NOT NULL,
    "question_id" TEXT,
    "user_answer" TEXT NOT NULL,
    "total_score" INTEGER NOT NULL,
    "grammar_score" INTEGER,
    "vocab_score" INTEGER,
    "speed_score" INTEGER,
    "intent_score" INTEGER,
    "response_time_sec" DOUBLE PRECISION,
    "feedback" JSONB,
    "xp_earned" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "translation_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "intent_questions" (
    "id" TEXT NOT NULL,
    "category" VARCHAR(50) NOT NULL,
    "level" "Level" NOT NULL,
    "intent_description" TEXT NOT NULL,
    "expected_expressions" JSONB NOT NULL,
    "alternative_phrases" JSONB NOT NULL,
    "difficulty" INTEGER NOT NULL DEFAULT 3,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "intent_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shadowing_contents" (
    "id" TEXT NOT NULL,
    "content_type" "ContentType" NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "level" "Level" NOT NULL,
    "transcript" TEXT NOT NULL,
    "audio_url" VARCHAR(500) NOT NULL,
    "timestamps" JSONB NOT NULL,
    "duration_sec" INTEGER NOT NULL,
    "is_premium" BOOLEAN NOT NULL DEFAULT false,
    "thumbnail_url" VARCHAR(500),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "shadowing_contents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quick_response_results" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "practice_type" "PracticeType" NOT NULL,
    "session_id" TEXT,
    "content_id" TEXT,
    "total_score" INTEGER NOT NULL,
    "correct_count" INTEGER,
    "max_chain" INTEGER,
    "following_score" INTEGER,
    "pronunciation_score" INTEGER,
    "rhythm_score" INTEGER,
    "duration_sec" INTEGER,
    "details" JSONB,
    "xp_earned" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "quick_response_results_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "translation_questions_topic_level_is_active_idx" ON "translation_questions"("topic", "level", "is_active");

-- CreateIndex
CREATE INDEX "translation_questions_level_difficulty_idx" ON "translation_questions"("level", "difficulty");

-- CreateIndex
CREATE INDEX "translation_results_user_id_practice_type_created_at_idx" ON "translation_results"("user_id", "practice_type", "created_at");

-- CreateIndex
CREATE INDEX "translation_results_user_id_created_at_idx" ON "translation_results"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "intent_questions_category_level_is_active_idx" ON "intent_questions"("category", "level", "is_active");

-- CreateIndex
CREATE INDEX "shadowing_contents_content_type_level_is_active_idx" ON "shadowing_contents"("content_type", "level", "is_active");

-- CreateIndex
CREATE INDEX "shadowing_contents_is_premium_is_active_idx" ON "shadowing_contents"("is_premium", "is_active");

-- CreateIndex
CREATE INDEX "quick_response_results_user_id_practice_type_created_at_idx" ON "quick_response_results"("user_id", "practice_type", "created_at");

-- AddForeignKey
ALTER TABLE "translation_results" ADD CONSTRAINT "translation_results_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "translation_results" ADD CONSTRAINT "translation_results_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "translation_questions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quick_response_results" ADD CONSTRAINT "quick_response_results_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
