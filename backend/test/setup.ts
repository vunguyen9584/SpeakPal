// Test setup file - loads test environment and configures global mocks
// This file is loaded BEFORE tests run via Jest's setupFilesAfterEnv

import * as dotenv from 'dotenv';
import * as path from 'path';

// Clear any existing Firebase env vars to ensure empty values
process.env.FIREBASE_PROJECT_ID = '';
process.env.FIREBASE_PRIVATE_KEY = '';
process.env.FIREBASE_CLIENT_EMAIL = '';

// Clear external API keys
process.env.OPENAI_API_KEY = '';
process.env.DEEPGRAM_API_KEY = '';
process.env.ELEVENLABS_API_KEY = '';

// Load test environment variables (will override the cleared values if defined)
dotenv.config({
    path: path.resolve(__dirname, '../.env.test'),
    override: true,
});

// Ensure NODE_ENV is test
process.env.NODE_ENV = 'test';

// Increase test timeout for E2E tests
jest.setTimeout(30000);
