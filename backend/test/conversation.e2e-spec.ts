import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from './../src/app.module';

describe('ConversationModule (e2e)', () => {
  let app: INestApplication;
  let authToken: string;
  let conversationId: string;

  const testUser = {
    email: `test_conv_e2e_${Date.now()}@example.com`,
    password: 'Password123!',
    username: `testuser_conv_${Date.now()}`,
  };

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    // Register user
    const res = await request(app.getHttpServer())
      .post('/auth/register')
      .send(testUser)
      .expect(201);

    authToken = res.body.accessToken;
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/conversations (POST)', () => {
    it('should create a new conversation (Free Talk)', () => {
      return request(app.getHttpServer())
        .post('/conversations')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          mode: 'FREE_TALK',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('websocketUrl');
          expect(res.body).toHaveProperty('token');
          expect(res.body.mode).toBe('FREE_TALK');
          conversationId = res.body.id;
        });
    });

    it('should create a new conversation with topic', () => {
      return request(app.getHttpServer())
        .post('/conversations')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          mode: 'FREE_TALK',
          topic: 'Travel',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body.topic).toBe('Travel');
        });
    });
  });

  describe('/conversations/:id (GET)', () => {
    it('should get conversation details', () => {
      return request(app.getHttpServer())
        .get(`/conversations/${conversationId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.id).toBe(conversationId);
          expect(res.body.status).toBeDefined();
        });
    });

    it('should fail for non-existent conversation', () => {
      return request(app.getHttpServer())
        .get('/conversations/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404);
    });
  });

  describe('/conversations (GET)', () => {
    it('should list conversations', () => {
      return request(app.getHttpServer())
        .get('/conversations')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body.data.some((c: any) => c.id === conversationId)).toBe(
            true,
          );
        });
    });
  });

  describe('/conversations/:id/end (POST)', () => {
    it('should end conversation', () => {
      return request(app.getHttpServer())
        .post(`/conversations/${conversationId}/end`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200) // Or 201 depending on implementation
        .expect((res) => {
          // Expect summary or status update
          // If it returns conversation, status should be ENDED or COMPLETED
          // But mostly we check success code
        });
    });
  });
});
