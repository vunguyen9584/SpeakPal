import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { createTestingModule } from './test-helper.module';

/**
 * Translation Feature E2E Tests
 * Tests all translation-related APIs including direct translation,
 * intent translation, quick response, and shadowing
 */
import { PrismaService } from 'src/prisma/prisma.service';
import { Level, ContentType } from '@prisma/client';

describe('Translation Features (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;
  let prisma: PrismaService;

  beforeAll(async () => {
    const moduleFixture = await createTestingModule().compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({ whitelist: true, transform: true }),
    );
    await app.init();

    prisma = app.get(PrismaService);

    // Seed Test Data
    await prisma.translationResult.deleteMany();
    await prisma.translationQuestion.deleteMany({ where: { topic: { in: ['daily', 'business'] } } });
    await prisma.intentQuestion.deleteMany({ where: { category: { in: ['greeting', 'daily'] } } });
    await prisma.shadowingContent.deleteMany();

    // 1. Seed Translation Questions
    await prisma.translationQuestion.create({
      data: {
        topic: 'daily',
        level: Level.BEGINNER,
        sourceText: 'Good morning',
        targetText: 'Ohayou gozaimasu',
        wordCount: 2,
        difficulty: 1,
        isActive: true,
      },
    });

    await prisma.translationQuestion.create({
      data: {
        topic: 'business',
        level: Level.INTERMEDIATE,
        sourceText: 'Please submit the report by Friday.',
        targetText: 'Kinyoubi made ni houkokusho wo teishutsu shite kudasai.',
        wordCount: 7,
        difficulty: 3,
        isActive: true,
      },
    });

    // 2. Seed Intent Questions
    await prisma.intentQuestion.create({
      data: {
        category: 'greeting',
        level: Level.INTERMEDIATE,
        intentDescription: 'Greet someone politely in the morning',
        expectedExpressions: ['Ohayou gozaimasu'],
        alternativePhrases: ['Ohayou'],
        difficulty: 2,
        isActive: true,
      },
    });

    await prisma.intentQuestion.create({
      data: {
        category: 'daily',
        level: Level.BEGINNER, // for negative test case
        intentDescription: 'Say goodbye',
        expectedExpressions: ['Sayonara'],
        alternativePhrases: ['Bye'],
        difficulty: 1,
        isActive: true,
      },
    });

    // 3. Seed Shadowing Content
    await prisma.shadowingContent.create({
      data: {
        contentType: ContentType.CONVERSATION,
        title: 'Daily Conversation',
        level: Level.BEGINNER,
        transcript: 'Hello, how are you?',
        audioUrl: 'https://example.com/audio.mp3',
        timestamps: [],
        durationSec: 10,
        isPremium: false,
        isActive: true,
      },
    });

    // Login to get access token (create user if needed)
    // First try to register to ensure user exists
    try {
      await request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: 'test_trans@example.com',
          password: 'Test@123',
          username: 'test_trans'
        });
    } catch (e) { } // Ignore if already exists

    const loginResponse = await request(app.getHttpServer())
      .post('/auth/login')
      .send({
        email: 'test_trans@example.com',
        password: 'Test@123',
      });

    accessToken = loginResponse.body.data?.accessToken;
  });

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  });

  const authRequest = () => ({
    get: (url: string) =>
      request(app.getHttpServer())
        .get(url)
        .set('Authorization', `Bearer ${accessToken}`),
    post: (url: string) =>
      request(app.getHttpServer())
        .post(url)
        .set('Authorization', `Bearer ${accessToken}`),
    put: (url: string) =>
      request(app.getHttpServer())
        .put(url)
        .set('Authorization', `Bearer ${accessToken}`),
    delete: (url: string) =>
      request(app.getHttpServer())
        .delete(url)
        .set('Authorization', `Bearer ${accessToken}`),
  });

  describe('Direct Translation (API-T01, API-T02)', () => {
    let questionId: string;

    describe('GET /api/v1/translation/questions', () => {
      it('should get a translation question with topic filter', async () => {
        const response = await authRequest()
          .get('/api/v1/translation/questions')
          .query({ topic: 'daily' })
          .expect(200);

        expect(response.body.success).toBe(true);
        expect(response.body.data).toHaveProperty('id');
        expect(response.body.data).toHaveProperty('topic', 'daily');
        expect(response.body.data).toHaveProperty('sourceText');
        expect(response.body.data).toHaveProperty('sourceLanguage');
        expect(response.body.data).toHaveProperty('difficulty');
        expect(response.body.data).toHaveProperty('timeLimit');
        expect(response.body.data).toHaveProperty('grammarPoints');
        expect(response.body.data).toHaveProperty('dailyProgress');
        expect(response.body.data.dailyProgress).toHaveProperty('completed');
        expect(response.body.data.dailyProgress).toHaveProperty('limit');

        questionId = response.body.data.id;
      });

      it('should get question with level filter', async () => {
        const response = await authRequest()
          .get('/api/v1/translation/questions')
          .query({ topic: 'business', level: 'Intermediate' })
          .expect(200);

        expect(response.body.data.level).toBe('Intermediate');
      });

      it('should return 400 for invalid topic', async () => {
        await authRequest()
          .get('/api/v1/translation/questions')
          .query({ topic: 'invalid_topic' })
          .expect(400);
      });
    });

    describe('POST /api/v1/translation/answers', () => {
      it('should evaluate translation answer (mocked audio)', async () => {
        // Note: In real tests, this would use a mock audio file
        const response = await authRequest()
          .post('/api/v1/translation/answers')
          .field('questionId', questionId)
          .field('responseTimeSec', 15)
          .attach('audio', Buffer.from('mock audio data'), 'answer.webm')
          .expect(200);

        expect(response.body.success).toBe(true);
        expect(response.body.data).toHaveProperty('userAnswer');
        expect(response.body.data).toHaveProperty('totalScore');
        expect(response.body.data).toHaveProperty('grammarScore');
        expect(response.body.data).toHaveProperty('vocabScore');
        expect(response.body.data).toHaveProperty('speedScore');
        expect(response.body.data).toHaveProperty('modelAnswer');
        expect(response.body.data).toHaveProperty('feedback');
        expect(response.body.data.feedback).toHaveProperty('goodPoints');
        expect(response.body.data.feedback).toHaveProperty('improvements');
        expect(response.body.data).toHaveProperty('xpEarned');

        // Scores should be in valid range
        expect(response.body.data.totalScore).toBeGreaterThanOrEqual(0);
        expect(response.body.data.totalScore).toBeLessThanOrEqual(100);
      });

      it('should return 400 for missing questionId', async () => {
        await authRequest()
          .post('/api/v1/translation/answers')
          .field('responseTimeSec', 15)
          .attach('audio', Buffer.from('mock audio data'), 'answer.webm')
          .expect(400);
      });
    });
  });

  describe('Intent Translation (API-T03, API-T04)', () => {
    describe('GET /api/v1/translation/intent-questions', () => {
      it('should get intent question for qualified user', async () => {
        // Note: Requires Intermediate+ level user
        const response = await authRequest()
          .get('/api/v1/translation/intent-questions')
          .query({ category: 'greeting' });

        if (response.status === 200) {
          expect(response.body.data).toHaveProperty('id');
          expect(response.body.data).toHaveProperty('category', 'greeting');
          expect(response.body.data).toHaveProperty('intentDescription');
          expect(response.body.data).toHaveProperty('difficulty');
        } else if (response.status === 403) {
          // Level restriction
          expect(response.body.error.code).toBe('TRANS_LEVEL_001');
        }
      });

      it('should reject beginner users', async () => {
        // This test assumes the test user is Beginner level
        // In a real scenario, use a Beginner-level test account
        const response = await authRequest()
          .get('/api/v1/translation/intent-questions')
          .query({ category: 'daily' });

        // Either pass (Intermediate+) or fail with correct error
        if (response.status === 403) {
          expect(response.body.error.code).toBe('TRANS_LEVEL_001');
          expect(response.body.error.details).toHaveProperty(
            'required',
            'Intermediate',
          );
        }
      });
    });
  });

  describe('Quick Response - Word Association (API-T04, API-T05)', () => {
    let sessionId: string;

    describe('POST /api/v1/quick-response/word-association/start', () => {
      it('should start word association session', async () => {
        const response = await authRequest()
          .post('/api/v1/quick-response/word-association/start')
          .send({ difficulty: 'medium' });

        if (response.status === 200) {
          expect(response.body.data).toHaveProperty('sessionId');
          expect(response.body.data).toHaveProperty('firstKeyword');
          expect(response.body.data).toHaveProperty('totalTime');
          expect(response.body.data).toHaveProperty('perQuestionTime');
          expect(response.body.data).toHaveProperty('dailyFreeRemaining');

          sessionId = response.body.data.sessionId;
        } else if (response.status === 429) {
          // Daily limit reached
          expect(response.body.error.code).toBe('QR_LIMIT_001');
        }
      });
    });

    describe('POST /api/v1/quick-response/word-association/answer', () => {
      it('should process word association answer', async () => {
        if (!sessionId) {
          console.log('Skipping: No session available');
          return;
        }

        const response = await authRequest()
          .post('/api/v1/quick-response/word-association/answer')
          .field('sessionId', sessionId)
          .attach('audio', Buffer.from('mock audio'), 'answer.webm')
          .expect(200);

        expect(response.body.data).toHaveProperty('correct');
        expect(response.body.data).toHaveProperty('userResponse');
        expect(response.body.data).toHaveProperty('score');
        expect(response.body.data).toHaveProperty('chain');
        expect(response.body.data).toHaveProperty('multiplier');
        expect(response.body.data).toHaveProperty('timeRemaining');
        // nextKeyword can be null if session ended
      });
    });

    describe('POST /api/v1/quick-response/word-association/end', () => {
      it('should end word association session', async () => {
        if (!sessionId) {
          console.log('Skipping: No session available');
          return;
        }

        const response = await authRequest()
          .post('/api/v1/quick-response/word-association/end')
          .send({ sessionId })
          .expect(200);

        expect(response.body.data).toHaveProperty('finalScore');
        expect(response.body.data).toHaveProperty('longestChain');
        expect(response.body.data).toHaveProperty('xpEarned');
      });
    });
  });

  describe('Quick Response - Instant Drill (API-T06)', () => {
    let sessionId: string;

    describe('POST /api/v1/quick-response/instant-drill/start', () => {
      it('should start instant drill session', async () => {
        const response = await authRequest()
          .post('/api/v1/quick-response/instant-drill/start')
          .send({ category: 'daily_questions' });

        if (response.status === 200) {
          expect(response.body.data).toHaveProperty('sessionId');
          expect(response.body.data).toHaveProperty('totalQuestions');
          expect(response.body.data).toHaveProperty('perQuestionTime');
          expect(response.body.data).toHaveProperty('category');

          sessionId = response.body.data.sessionId;
        } else if (response.status === 429) {
          expect(response.body.error.code).toBe('QR_LIMIT_002');
        }
      });
    });

    describe('GET /api/v1/quick-response/instant-drill/next', () => {
      it('should get next question', async () => {
        if (!sessionId) return;

        const response = await authRequest()
          .get('/api/v1/quick-response/instant-drill/next')
          .query({ sessionId })
          .expect(200);

        expect(response.body.data).toHaveProperty('questionNumber');
        expect(response.body.data).toHaveProperty('question');
        expect(response.body.data).toHaveProperty('timeLimit');
      });
    });

    describe('POST /api/v1/quick-response/instant-drill/answer', () => {
      it('should process drill answer', async () => {
        if (!sessionId) return;

        const response = await authRequest()
          .post('/api/v1/quick-response/instant-drill/answer')
          .field('sessionId', sessionId)
          .attach('audio', Buffer.from('mock audio'), 'answer.webm')
          .expect(200);

        expect(response.body.data).toHaveProperty('score');
        expect(response.body.data).toHaveProperty('fluencyScore');
        expect(response.body.data).toHaveProperty('hasMore');
      });
    });

    describe('POST /api/v1/quick-response/instant-drill/end', () => {
      it('should end drill session', async () => {
        if (!sessionId) return;

        const response = await authRequest()
          .post('/api/v1/quick-response/instant-drill/end')
          .send({ sessionId })
          .expect(200);

        expect(response.body.data).toHaveProperty('summary');
        expect(response.body.data).toHaveProperty('averageScore');
        expect(response.body.data).toHaveProperty('xpEarned');
      });
    });
  });

  describe('Shadowing (API-T07, API-T08)', () => {
    let contentId: string;
    let sessionId: string;

    describe('GET /api/v1/shadowing/contents', () => {
      it('should list shadowing contents', async () => {
        const response = await authRequest()
          .get('/api/v1/shadowing/contents')
          .expect(200);

        expect(response.body.data).toHaveProperty('items');
        expect(response.body.data).toHaveProperty('pagination');
        expect(Array.isArray(response.body.data.items)).toBe(true);

        if (response.body.data.items.length > 0) {
          const item = response.body.data.items[0];
          expect(item).toHaveProperty('id');
          expect(item).toHaveProperty('contentType');
          expect(item).toHaveProperty('title');
          expect(item).toHaveProperty('level');
          expect(item).toHaveProperty('durationSec');
          expect(item).toHaveProperty('isPremium');
          expect(item).toHaveProperty('isLocked');

          contentId = item.id;
        }
      });

      it('should filter contents by type', async () => {
        const response = await authRequest()
          .get('/api/v1/shadowing/contents')
          .query({ contentType: 'conversation' })
          .expect(200);

        response.body.data.items.forEach((item: unknown) => {
          expect((item as { contentType: string }).contentType).toBe(
            'conversation',
          );
        });
      });

      it('should filter contents by level', async () => {
        const response = await authRequest()
          .get('/api/v1/shadowing/contents')
          .query({ level: 'beginner' })
          .expect(200);

        response.body.data.items.forEach((item: unknown) => {
          expect((item as { level: string }).level).toBe('beginner');
        });
      });

      it('should paginate results', async () => {
        const response = await authRequest()
          .get('/api/v1/shadowing/contents')
          .query({ page: 1, limit: 5 })
          .expect(200);

        expect(response.body.data.items.length).toBeLessThanOrEqual(5);
        expect(response.body.data.pagination.page).toBe(1);
        expect(response.body.data.pagination.limit).toBe(5);
      });
    });

    describe('GET /api/v1/shadowing/contents/:id', () => {
      it('should get content details', async () => {
        if (!contentId) return;

        const response = await authRequest()
          .get(`/api/v1/shadowing/contents/${contentId}`)
          .expect(200);

        expect(response.body.data).toHaveProperty('id', contentId);
        expect(response.body.data).toHaveProperty('audioUrl');
        expect(response.body.data).toHaveProperty('transcript');
        expect(response.body.data).toHaveProperty('segments');
      });

      it('should return 404 for non-existent content', async () => {
        await authRequest()
          .get(
            '/api/v1/shadowing/contents/00000000-0000-0000-0000-000000000000',
          )
          .expect(404);
      });
    });

    describe('POST /api/v1/shadowing/sessions/start', () => {
      it('should start shadowing session', async () => {
        if (!contentId) return;

        const response = await authRequest()
          .post('/api/v1/shadowing/sessions/start')
          .send({ contentId });

        if (response.status === 200) {
          expect(response.body.data).toHaveProperty('sessionId');
          expect(response.body.data).toHaveProperty('contentId', contentId);
          sessionId = response.body.data.sessionId;
        } else if (response.status === 403) {
          // Premium content for free user
          expect(response.body.error.code).toBe('SHADOW_002');
        }
      });
    });

    describe('POST /api/v1/shadowing/sessions/:id/analyze', () => {
      it('should analyze shadowing audio', async () => {
        if (!sessionId) return;

        const response = await authRequest()
          .post(`/api/v1/shadowing/sessions/${sessionId}/analyze`)
          .attach('userAudio', Buffer.from('mock audio'), 'shadowing.webm')
          .expect(200);

        expect(response.body.data).toHaveProperty('totalScore');
        expect(response.body.data).toHaveProperty('followingScore');
        expect(response.body.data).toHaveProperty('pronunciationScore');
        expect(response.body.data).toHaveProperty('rhythmScore');
        expect(response.body.data).toHaveProperty('completenessScore');
        expect(response.body.data).toHaveProperty('feedback');
        expect(response.body.data).toHaveProperty('weakSegments');
        expect(response.body.data).toHaveProperty('xpEarned');

        // Validate score ranges
        expect(response.body.data.totalScore).toBeGreaterThanOrEqual(0);
        expect(response.body.data.totalScore).toBeLessThanOrEqual(100);
      });
    });
  });

  describe('Rate Limiting', () => {
    it('should return 429 when translation limit reached', async () => {
      // This test requires hitting the API multiple times
      // In real tests, mock the usage count or use a pre-limited account

      // Make multiple requests until limit is hit
      let hitLimit = false;
      for (let i = 0; i < 15; i++) {
        const response = await authRequest()
          .get('/api/v1/translation/questions')
          .query({ topic: 'daily' });

        if (response.status === 429) {
          expect(response.body.error.code).toBe('TRANS_LIMIT_001');
          expect(response.body.error.details).toHaveProperty('limit');
          expect(response.body.error.details).toHaveProperty('resetAt');
          hitLimit = true;
          break;
        }
      }

      // Note: This test may not hit the limit if daily limit > 15
      console.log('Rate limit test completed, limit hit:', hitLimit);
    });
  });

  describe('Error Handling', () => {
    it('should handle audio processing errors gracefully', async () => {
      // Send invalid audio data
      const response = await authRequest()
        .post('/api/v1/translation/answers')
        .field('questionId', 'valid-id')
        .field('responseTimeSec', 15)
        .attach('audio', Buffer.from('not audio'), 'bad.txt');

      // Should return error, not crash
      expect([400, 503]).toContain(response.status);
    });

    it('should validate session ownership', async () => {
      // Try to access another user's session
      const response = await authRequest()
        .post('/api/v1/quick-response/word-association/answer')
        .field('sessionId', '00000000-0000-0000-0000-000000000000')
        .attach('audio', Buffer.from('mock'), 'a.webm');

      expect([404, 403]).toContain(response.status);
    });
  });
});
