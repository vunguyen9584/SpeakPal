/**
 * WebSocket Test Client for TTS & Audio Streaming
 * 
 * This script demonstrates how to connect to the WebSocket gateway
 * and use the TTS (Text-to-Speech) functionality with mock TTS service.
 * 
 * Usage:
 *   node test-websocket-client.js
 * 
 * Or with ts-node:
 *   npx ts-node test-websocket-client.ts
 */

import { io, Socket } from 'socket.io-client';
import * as fs from 'fs';
import * as path from 'path';

// Configuration
const WS_URL = 'http://localhost:3000/ws/conversation';
const JWT_TOKEN = 'your_jwt_token_here'; // Replace with actual token
const CONVERSATION_ID = 'test-conversation-id'; // Replace with actual conversation ID

class WebSocketTTSClient {
    private socket: Socket | null = null;
    private audioChunks: Buffer[] = [];

    constructor(
        private url: string,
        private token: string,
        private conversationId: string,
    ) { }

    /**
     * Connect to WebSocket server
     */
    connect(): Promise<void> {
        return new Promise((resolve, reject) => {
            console.log('🔌 Connecting to WebSocket server...');

            this.socket = io(this.url, {
                auth: {
                    token: this.token,
                    conversationId: this.conversationId,
                },
                transports: ['websocket'],
            });

            // Connection events
            this.socket.on('connect', () => {
                console.log('✅ Connected to WebSocket server');
                console.log(`   Session ID: ${this.socket?.id}`);
            });

            this.socket.on('connected', (data) => {
                console.log('✅ Session established:', data);
                resolve();
            });

            this.socket.on('connect_error', (error) => {
                console.error('❌ Connection error:', error.message);
                reject(error);
            });

            this.socket.on('error', (error) => {
                console.error('❌ WebSocket error:', error);
            });

            this.socket.on('disconnect', (reason) => {
                console.log('🔌 Disconnected:', reason);
            });

            // Setup TTS event listeners
            this.setupTTSListeners();
        });
    }

    /**
     * Setup TTS event listeners
     */
    private setupTTSListeners() {
        if (!this.socket) return;

        // TTS Start
        this.socket.on('tts_start', (data) => {
            console.log('\n🎤 TTS Started:');
            console.log(`   TTS ID: ${data.ttsId}`);
            console.log(`   Text: "${data.text}"`);
            console.log(`   Voice: ${data.voice}`);
            this.audioChunks = [];
        });

        // TTS Audio Chunk
        this.socket.on('tts_audio_chunk', (data) => {
            const chunk = Buffer.from(data.chunk, 'base64');
            this.audioChunks.push(chunk);
            console.log(`   📦 Chunk ${data.sequence}: ${data.size} bytes`);
        });

        // TTS Complete
        this.socket.on('tts_complete', (data) => {
            console.log('\n✅ TTS Completed:');
            console.log(`   Total chunks: ${data.totalChunks}`);
            console.log(`   Total bytes: ${data.totalBytes}`);
            console.log(`   Duration: ~${data.duration}s`);

            // Save audio to file
            if (this.audioChunks.length > 0) {
                this.saveAudio(data.ttsId);
            }
        });

        // TTS Error
        this.socket.on('tts_error', (data) => {
            console.error('❌ TTS Error:', data.error);
        });

        // Word Pronunciation
        this.socket.on('word_pronunciation', (data) => {
            console.log('\n🔊 Word Pronunciation:');
            console.log(`   Word: "${data.word}"`);
            console.log(`   Language: ${data.language}`);
            console.log(`   Audio size: ${Buffer.from(data.audio, 'base64').length} bytes`);

            // Save pronunciation audio
            this.savePronunciation(data.word, data.audio);
        });
    }

    /**
     * Request TTS for text
     */
    requestTTS(text: string, voice: 'male' | 'female' | 'neutral' = 'female') {
        if (!this.socket) {
            console.error('❌ Not connected to WebSocket');
            return;
        }

        console.log(`\n🎯 Requesting TTS for: "${text}"`);
        this.socket.emit('tts_request', { text, voice });
    }

    /**
     * Request word pronunciation
     */
    pronounceWord(word: string, language: string = 'en') {
        if (!this.socket) {
            console.error('❌ Not connected to WebSocket');
            return;
        }

        console.log(`\n🎯 Requesting pronunciation for: "${word}"`);
        this.socket.emit('pronounce_word', { word, language });
    }

    /**
     * Send audio stream chunk
     */
    sendAudioChunk(chunk: Buffer, sequence: number, isFinal: boolean = false) {
        if (!this.socket) {
            console.error('❌ Not connected to WebSocket');
            return;
        }

        this.socket.emit('audio_stream', {
            chunk: chunk.toString('base64'),
            sequence,
            isFinal,
        });
    }

    /**
     * Save audio to file
     */
    private saveAudio(ttsId: string) {
        const outputDir = path.join(__dirname, 'output');
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        const filename = path.join(outputDir, `${ttsId}.raw`);
        const completeAudio = Buffer.concat(this.audioChunks);

        fs.writeFileSync(filename, completeAudio);
        console.log(`   💾 Audio saved to: ${filename}`);
        console.log(`   ℹ️  This is raw audio data (mock). In production, it would be MP3/WAV.`);
    }

    /**
     * Save pronunciation audio
     */
    private savePronunciation(word: string, audioBase64: string) {
        const outputDir = path.join(__dirname, 'output');
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        const filename = path.join(outputDir, `pronunciation_${word}.raw`);
        const audio = Buffer.from(audioBase64, 'base64');

        fs.writeFileSync(filename, audio);
        console.log(`   💾 Pronunciation saved to: ${filename}`);
    }

    /**
     * Disconnect from server
     */
    disconnect() {
        if (this.socket) {
            this.socket.disconnect();
            this.socket = null;
            console.log('\n👋 Disconnected from server');
        }
    }
}

// ============================================================================
// Demo Usage
// ============================================================================

async function runDemo() {
    console.log('🚀 WebSocket TTS Client Demo\n');
    console.log('⚠️  Make sure to:');
    console.log('   1. Backend server is running (npm run start:dev)');
    console.log('   2. Replace JWT_TOKEN with a valid token');
    console.log('   3. Replace CONVERSATION_ID with a valid conversation ID\n');

    const client = new WebSocketTTSClient(WS_URL, JWT_TOKEN, CONVERSATION_ID);

    try {
        // Connect to server
        await client.connect();

        // Wait a bit for connection to stabilize
        await sleep(1000);

        // Test 1: Simple TTS request
        console.log('\n📝 Test 1: Simple TTS Request');
        client.requestTTS('Hello! This is a test of the text to speech system.', 'female');
        await sleep(3000);

        // Test 2: Different voice
        console.log('\n📝 Test 2: Male Voice');
        client.requestTTS('This is using a male voice.', 'male');
        await sleep(3000);

        // Test 3: Word pronunciation
        console.log('\n📝 Test 3: Word Pronunciation');
        client.pronounceWord('pronunciation');
        await sleep(2000);

        // Test 4: Multiple words
        console.log('\n📝 Test 4: Multiple Words');
        const words = ['hello', 'world', 'vocabulary'];
        for (const word of words) {
            client.pronounceWord(word);
            await sleep(1500);
        }

        // Test 5: Long text
        console.log('\n📝 Test 5: Long Text');
        const longText = 'This is a longer text to test the streaming capabilities of the text to speech system. It should be split into multiple chunks and streamed to the client in real-time.';
        client.requestTTS(longText, 'neutral');
        await sleep(5000);

        console.log('\n✅ All tests completed!');
        console.log('📁 Check the "output" folder for saved audio files.');

    } catch (error) {
        console.error('\n❌ Demo failed:', error);
    } finally {
        // Disconnect
        await sleep(1000);
        client.disconnect();
    }
}

// Helper function
function sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Run demo if this file is executed directly
if (require.main === module) {
    runDemo().catch(console.error);
}

// Export for use as module
export { WebSocketTTSClient };
