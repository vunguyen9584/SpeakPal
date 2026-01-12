/**
 * Test OpenAI TTS Service
 * 
 * Usage: npx ts-node test-openai-tts.ts
 */

import { NestFactory } from '@nestjs/core';
import { AppModule } from './src/app.module';
import { OpenAITTSService } from './src/integrations/openai-tts/openai-tts.service';
import * as fs from 'fs';
import * as path from 'path';

async function testOpenAITTS() {
    console.log('🎤 Testing OpenAI TTS Service\n');

    // Create NestJS application context
    const app = await NestFactory.createApplicationContext(AppModule, {
        logger: ['error', 'warn', 'log'],
    });

    try {
        // Get OpenAI TTS service
        const ttsService = app.get(OpenAITTSService);

        // Check if configured
        if (!ttsService.isAvailable()) {
            console.log('⚠️  OpenAI TTS is not configured!');
            console.log('');
            console.log('To use OpenAI TTS, add to your .env file:');
            console.log('   OPENAI_API_KEY=your_api_key_here');
            console.log('   OPENAI_TTS_MODEL=tts-1');
            console.log('   OPENAI_TTS_VOICE=alloy');
            console.log('   OPENAI_TTS_FORMAT=mp3');
            console.log('   OPENAI_TTS_SPEED=1');
            console.log('');
            console.log('Get your API key at: https://platform.openai.com/api-keys');
            return;
        }

        console.log('✅ OpenAI TTS service loaded\n');

        // Test 1: Get available voices
        console.log('📝 Test 1: Getting available voices...');
        const voices = ttsService.getAvailableVoices();
        console.log(`✅ Found ${voices.length} voices:`);
        voices.forEach((voice) => {
            console.log(`   - ${voice.name} (${voice.voice_id}) - ${voice.category} - ${voice.description}`);
        });
        console.log('');

        // Test 2: Simple TTS (synchronous)
        console.log('📝 Test 2: Testing synchronous TTS...');
        const testText = 'Hello! This is a test of the OpenAI text to speech system.';
        console.log(`   Text: "${testText}"`);
        console.log(`   Voice: female (Nova)`);

        const startTime = Date.now();

        const audio = await ttsService.textToSpeech({
            text: testText,
            voice: 'female',
            speed: 1,
        });

        const duration = Date.now() - startTime;

        console.log(`✅ Audio generated successfully!`);
        console.log(`   Size: ${audio.length} bytes`);
        console.log(`   Time: ${duration}ms`);
        console.log('');

        // Save audio
        const outputDir = path.join(__dirname, 'test-output');
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        const filename = path.join(outputDir, 'openai-tts-test.mp3');
        fs.writeFileSync(filename, audio);
        console.log(`   💾 Saved to: ${filename}`);
        console.log('');

        // Test 3: Streaming TTS
        console.log('📝 Test 3: Testing streaming TTS...');
        const streamText = 'This is a streaming test. The audio is delivered in chunks.';
        console.log(`   Text: "${streamText}"`);

        const chunks: Buffer[] = [];
        let chunkCount = 0;
        const streamStartTime = Date.now();

        for await (const chunk of ttsService.textToSpeechStreaming({
            text: streamText,
            voice: 'male',
        })) {
            chunks.push(chunk);
            chunkCount++;
            console.log(`   📦 Chunk ${chunkCount}: ${chunk.length} bytes`);
        }

        const streamDuration = Date.now() - streamStartTime;
        const totalSize = chunks.reduce((sum, chunk) => sum + chunk.length, 0);

        console.log(`✅ Streaming completed!`);
        console.log(`   Total chunks: ${chunkCount}`);
        console.log(`   Total size: ${totalSize} bytes`);
        console.log(`   Time: ${streamDuration}ms`);
        console.log('');

        // Save streamed audio
        const streamFilename = path.join(outputDir, 'openai-tts-streaming.mp3');
        const completeAudio = Buffer.concat(chunks);
        fs.writeFileSync(streamFilename, completeAudio);
        console.log(`   💾 Saved to: ${streamFilename}`);
        console.log('');

        // Test 4: Different voices
        console.log('📝 Test 4: Testing different voices...');
        const voiceTests = [
            { text: 'This is a female voice.', voice: 'female' as const },
            { text: 'This is a male voice.', voice: 'male' as const },
            { text: 'This is a neutral voice.', voice: 'neutral' as const },
        ];

        for (const test of voiceTests) {
            console.log(`   Testing ${test.voice} voice...`);

            const audio = await ttsService.textToSpeech({
                text: test.text,
                voice: test.voice,
            });

            const filename = path.join(outputDir, `openai-tts-${test.voice}.mp3`);
            fs.writeFileSync(filename, audio);

            console.log(`   ✅ ${test.voice}: ${audio.length} bytes → ${filename}`);
        }
        console.log('');

        // Summary
        console.log('═══════════════════════════════════════════════════════');
        console.log('✅ All OpenAI TTS tests passed!');
        console.log('');
        console.log('📊 Summary:');
        console.log('   - Voices: 6 available');
        console.log('   - Synchronous TTS: ✅ Working');
        console.log('   - Streaming TTS: ✅ Working');
        console.log('   - Voice selection: ✅ Working');
        console.log('');
        console.log('📁 Audio files saved to: test-output/');
        console.log('🎧 Play the MP3 files to verify audio quality.');
        console.log('═══════════════════════════════════════════════════════\n');

    } catch (error: any) {
        console.error('\n❌ Test failed:', error.message);

        if (error.response) {
            console.error('Response status:', error.response.status);
            console.error('Response data:', error.response.data);
        }

        console.log('\n💡 Troubleshooting:');
        console.log('   - Check your API key is valid');
        console.log('   - Ensure you have credits available');
        console.log('   - Visit: https://platform.openai.com/account/usage');

        process.exit(1);
    } finally {
        await app.close();
    }
}

// Run tests
testOpenAITTS()
    .then(() => {
        console.log('👋 OpenAI TTS test completed successfully!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Test failed with error:', error);
        process.exit(1);
    });
