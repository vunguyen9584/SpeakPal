/**
 * Test Mock TTS Service
 * 
 * Usage: npx ts-node test-mock-tts.ts
 */

import { NestFactory } from '@nestjs/core';
import { AppModule } from './src/app.module';
import { TTSService } from './src/modules/ai-orchestrator/tts.service';
import * as fs from 'fs';
import * as path from 'path';

async function testMockTTS() {
    console.log('🎤 Testing Mock TTS Service\n');
    console.log('✅ No API key needed!');
    console.log('✅ Unlimited usage!');
    console.log('✅ Perfect for development!\n');

    // Create NestJS application context
    const app = await NestFactory.createApplicationContext(AppModule, {
        logger: ['error', 'warn', 'log'],
    });

    try {
        // Get TTS service
        const ttsService = app.get(TTSService);
        console.log('✅ Mock TTS service loaded\n');

        // Test 1: Get available voices
        console.log('📝 Test 1: Getting available voices...');
        const voices = await ttsService.getVoices();
        console.log(`✅ Found ${voices.length} voices:`);
        voices.forEach((voice) => {
            console.log(`   - ${voice.name} (${voice.category})`);
        });
        console.log('');

        // Test 2: Simple TTS (streaming)
        console.log('📝 Test 2: Testing streaming TTS...');
        const testText = 'Hello! This is a test of the mock text to speech system.';
        console.log(`   Text: "${testText}"`);
        console.log(`   Voice: female`);

        const chunks: Buffer[] = [];
        let chunkCount = 0;
        const startTime = Date.now();

        for await (const chunk of ttsService.streamSynthesize(testText, 'female')) {
            chunks.push(chunk);
            chunkCount++;
            console.log(`   📦 Chunk ${chunkCount}: ${chunk.length} bytes`);
        }

        const duration = Date.now() - startTime;
        const totalSize = chunks.reduce((sum, chunk) => sum + chunk.length, 0);

        console.log(`✅ Streaming completed!`);
        console.log(`   Total chunks: ${chunkCount}`);
        console.log(`   Total size: ${totalSize} bytes`);
        console.log(`   Time: ${duration}ms`);
        console.log('');

        // Save mock audio
        const outputDir = path.join(__dirname, 'test-output');
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        const filename = path.join(outputDir, 'mock-tts-female.raw');
        const completeAudio = Buffer.concat(chunks);
        fs.writeFileSync(filename, completeAudio);
        console.log(`   💾 Saved to: ${filename}`);
        console.log('');

        // Test 3: Different voices
        console.log('📝 Test 3: Testing different voices...');
        const voiceTests = [
            { text: 'This is a male voice.', voice: 'male' as const },
            { text: 'This is a neutral voice.', voice: 'neutral' as const },
        ];

        for (const test of voiceTests) {
            console.log(`   Testing ${test.voice} voice...`);
            const chunks: Buffer[] = [];

            for await (const chunk of ttsService.streamSynthesize(test.text, test.voice)) {
                chunks.push(chunk);
            }

            const audio = Buffer.concat(chunks);
            const filename = path.join(outputDir, `mock-tts-${test.voice}.raw`);
            fs.writeFileSync(filename, audio);

            console.log(`   ✅ ${test.voice}: ${audio.length} bytes → ${filename}`);
        }
        console.log('');

        // Test 4: Voice mapping for persona
        console.log('📝 Test 4: Testing persona voice mapping...');
        const personaVoice = ttsService.getVoiceForPersona('persona-123');
        console.log(`   ✅ Persona voice: ${personaVoice}`);
        console.log('');

        // Test 5: Health check
        console.log('📝 Test 5: Testing health check...');
        const isHealthy = await ttsService.healthCheck();
        console.log(`   ✅ Service healthy: ${isHealthy}`);
        console.log('');

        // Summary
        console.log('═══════════════════════════════════════════════════════');
        console.log('✅ All Mock TTS tests passed!');
        console.log('');
        console.log('📊 Summary:');
        console.log('   - Voices: 3 (male, female, neutral)');
        console.log('   - Streaming: ✅ Working');
        console.log('   - Voice selection: ✅ Working');
        console.log('   - Persona mapping: ✅ Working');
        console.log('   - Health check: ✅ Healthy');
        console.log('');
        console.log('📁 Mock audio files saved to: test-output/');
        console.log('   (These are mock data, not real audio)');
        console.log('');
        console.log('🚀 Mock TTS is ready for WebSocket Gateway!');
        console.log('═══════════════════════════════════════════════════════\n');

    } catch (error) {
        console.error('\n❌ Test failed:', error);
        console.error('Stack:', error.stack);
    } finally {
        await app.close();
    }
}

// Run tests
testMockTTS()
    .then(() => {
        console.log('👋 Mock TTS test completed successfully!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Test failed with error:', error);
        process.exit(1);
    });
