# 🚀 Technical Debt Resolution - Phases 2-4

**Continuation of:** TECHNICAL_DEBT_RESOLUTION_PLAN.md (Phase 1)

---

# 🎯 Phase 2: Core Feature Completion (Days 8-14)

**Objective:** Implement critical missing features identified trong audit với production-grade quality

**Duration:** 7 days  
**Issues Addressed:** 25 (Audit IDs #2, #6, #7, #8, #11, #22, #27, #28, #32, #33, etc.)

---

## WP-P2-001: Shadowing Practice - Audio Integration

**Owner:** Mobile Audio Specialist  
**Duration:** 3 days  
**Priority:** 🔴 Critical  
**Audit IDs:** #6, #22, #54

### Implementation Checklist

#### Day 1: Backend Integration & Data Flow

- [x] **T001: API Integration**

  ```dart
  // lib/features/translation/data/translation_repository.dart

  @override
  Future<Either<AppError, List<ShadowingContent>>> getShadowingContent({
    required Difficulty difficulty,
    required Topic topic,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/translation/shadowing-content',
        queryParameters: {
          'difficulty': difficulty.name,
          'topic': topic.name,
        },
      );

      final contents = (response.data!['contents'] as List)
          .map((json) => ShadowingContent.fromJson(json))
          .toList();

      return Right(contents);

    } on AppError catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      logger.error('Failed to load shadowing content', error: e, stackTrace: stackTrace);
      return Left(NetworkError('Failed to load content', originalError: e));
    }
  }
  ```

  **DoD:**

  - [x] API endpoint integrated
  - [x] Error handling implemented
  - [x] Unit tests for repository (mock API responses)

- [x] **T002: Update Content Model**

  ```dart
  // lib/features/translation/models/shadowing_content.dart

  @freezed
  class ShadowingContent with _$ShadowingContent {
    const factory ShadowingContent({
      required String id,
      required String title,
      required String description,
      required Difficulty difficulty,
      required Topic topic,
      required String text,
      required String audioUrl,  // ✅ No longer empty
      required Duration duration,
      required bool isPremium,
      required List<TextSegment> segments,
    }) = _ShadowingContent;

    factory ShadowingContent.fromJson(Map<String, dynamic> json) =>
        _$ShadowingContentFromJson(json);
  }

  @freezed
  class TextSegment with _$TextSegment {
    const factory TextSegment({
      required String id,
      required String text,
      required Duration startTime,
      required Duration endTime,
    }) = _TextSegment;

    factory TextSegment.fromJson(Map<String, dynamic> json) =>
        _$TextSegmentFromJson(json);
  }
  ```

  **DoD:**

  - [x] Model updated với real data structure
  - [x] JSON serialization working
  - [x] Build runner executed successfully

#### Day 2: Audio Player Implementation

- [x] **T003: Create Audio Player Service**

  ```dart
  // lib/features/translation/services/shadowing_audio_service.dart

  import 'package:just_audio/just_audio.dart';
  import 'package:audio_session/audio_session.dart';

  class ShadowingAudioService {
    final AudioPlayer _modelPlayer = AudioPlayer();
    final AudioPlayer _userPlayer = AudioPlayer();

    // Streams
    Stream<Duration> get modelPosition => _modelPlayer.positionStream;
    Stream<PlaybackState> get modelState => _modelPlayer.playbackEventStream
        .map((event) => _mapToPlaybackState(event));

    Future<void> initialize(String audioUrl) async {
      try {
        // Configure audio session
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.speech());

        // Load audio
        await _modelPlayer.setUrl(audioUrl);

        logger.info('Shadowing audio initialized', data: {'url': audioUrl});

      } catch (e, stackTrace) {
        logger.error('Failed to initialize audio', error: e, stackTrace: stackTrace);
        throw MediaError(
          'Failed to load audio',
          userMessage: 'Could not load audio. Please check your connection',
          originalError: e,
        );
      }
    }

    Future<void> play() async {
      try {
        await _modelPlayer.play();
      } catch (e) {
        throw MediaError('Playback failed', originalError: e);
      }
    }

    Future<void> pause() async {
      await _modelPlayer.pause();
    }

    Future<void> seek(Duration position) async {
      await _modelPlayer.seek(position);
    }

    Future<void> setPlaybackSpeed(double speed) async {
      await _modelPlayer.setSpeed(speed);
    }

    // Simultaneous playback + recording for shadowing
    Future<void> startShadowing({
      required String recordingPath,
    }) async {
      // Start model playback
      await _modelPlayer.play();

      // Start recording with slight delay for user to hear first
      await Future.delayed(const Duration(milliseconds: 100));
      // Recording logic here (integrated with existing recording service)
    }

    Future<void> dispose() async {
      await _modelPlayer.dispose();
      await _userPlayer.dispose();
    }
  }
  ```

  **DoD:**

  - [x] Audio player service implemented
  - [x] Playback controls working (play/pause/seek/speed)
  - [x] Error handling for network/playback issues
  - [x] Unit tests for service logic

- [x] **T004: Integrate with Shadowing Player Screen**

  ```dart
  // lib/features/translation/screens/shadowing_player_screen.dart updates

  class _ShadowingPlayerScreenState extends ConsumerState<ShadowingPlayerScreen> {
    late ShadowingAudioService _audioService;

    @override
    void initState() {
      super.initState();
      _audioService = ShadowingAudioService();
      _initializeAudio();
    }

    Future<void> _initializeAudio() async {
      try {
        await _audioService.initialize(widget.content.audioUrl);
        setState(() => _isReady = true);
      } on MediaError catch (e) {
        if (!mounted) return;
        errorHandler.handleError(e, context: context);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _isReady
            ? _buildPlayerInterface()
            : _buildLoadingState(),
      );
    }

    Widget _buildPlayerInterface() {
      return Column(
        children: [
          // Waveform visualization
          StreamBuilder<Duration>(
            stream: _audioService.modelPosition,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              return AudioWaveformVisualizer(
                position: position,
                duration: widget.content.duration,
                segments: widget.content.segments,
              );
            },
          ),

          // Playback controls
          PlaybackControls(
            onPlay: _audioService.play,
            onPause: _audioService.pause,
            onSeek: _audioService.seek,
            onSpeedChange: _audioService.setPlaybackSpeed,
          ),

          // Start shadowing button
          ElevatedButton(
            onPressed: _startShadowing,
            child: const Text('Start Shadowing'),
          ),
        ],
      );
    }

    Future<void> _startShadowing() async {
      // Check headphones
      if (!await _checkHeadphones()) {
        _showHeadphoneWarning();
        return;
      }

      await _audioService.startShadowing(
        recordingPath: _getRecordingPath(),
      );
    }

    @override
    void dispose() {
      _audioService.dispose();
      super.dispose();
    }
  }
  ```

  **DoD:**

  - [x] Audio loads from backend URL (no more empty strings)
  - [x] Player controls functional
  - [x] Loading/error states handled
  - [x] Widget tests updated

#### Day 3: Headphone Detection & Polish

- [ ] **T005: Implement Headphone Detection**

  ```dart
  // lib/features/translation/utils/headphone_detector.dart

  import 'package:audio_session/audio_session.dart';

  class HeadphoneDetector {
    static Future<bool> areHeadphonesConnected() async {
      try {
        final session = await AudioSession.instance;

        // Check current output devices
        final configuration = session.configuration;

        // Platform-specific detection
        // iOS: Check AVAudioSession route
        // Android: Check AudioManager

        // Simplified implementation:
        // In production, use platform channels for accurate detection
        return true; // Placeholder - implement platform-specific

      } catch (e) {
        logger.warning('Headphone detection failed', error: e);
        return false; // Assume not connected on error
      }
    }

    static Future<void> showHeadphoneWarning(BuildContext context) async {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🎧 Headphones Required'),
          content: const Text(
            'For the best shadowing experience, please connect headphones. '
            'This prevents the model audio from interfering with your recording.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Proceed anyway
              },
              child: const Text('Continue Anyway'),
            ),
          ],
        ),
      );
    }
  }
  ```

  **DoD:**

  - [ ] Headphone detection implemented
  - [ ] Warning dialog shown khi không có headphones
  - [ ] User can still proceed (warning only, not blocking)

- [ ] **T006: Audio Caching Implementation**

  ```dart
  // lib/features/translation/services/audio_cache_service.dart

  import 'package:path_provider/path_provider.dart';
  import 'package:dio/dio.dart';
  import 'dart:io';

  class AudioCacheService {
    static const String _cacheFolder = 'shadowing_audio';

    Future<String> getOrDownloadAudio(String audioUrl) async {
      final cacheDir = await _getCacheDirectory();
      final filename = _getFilenameFromUrl(audioUrl);
      final cachePath = '${cacheDir.path}/$filename';

      // Check if already cached
      final cacheFile = File(cachePath);
      if (await cacheFile.exists()) {
        logger.debug('Audio cache hit', data: {'url': audioUrl});
        return cachePath;
      }

      // Download and cache
      logger.info('Downloading audio for cache', data: {'url': audioUrl});
      await Dio().download(audioUrl, cachePath);

      return cachePath;
    }

    Future<Directory> _getCacheDirectory() async {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${appDir.path}/$_cacheFolder');

      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      return cacheDir;
    }

    String _getFilenameFromUrl(String url) {
      return url.split('/').last.replaceAll(RegExp(r'[^\w\-\.]'), '_');
    }

    Future<void> clearCache() async {
      final cacheDir = await _getCacheDirectory();
      await cacheDir.delete(recursive: true);
    }
  }
  ```

  **DoD:**

  - [ ] Audio files cached locally after first download
  - [ ] Subsequent plays use cached version
  - [ ] Cache management (clear old files)

### Testing Requirements

- [ ] **Unit Tests:**

  - ShadowingAudioService: playback controls
  - AudioCacheService: download + cache logic
  - Repository: API integration

- [ ] **Widget Tests:**

  - ShadowingPlayerScreen: loading → ready → playing states
  - Error handling: network failure, audio load failure

- [ ] **Integration Test:**

  - End-to-end: select content → load audio → play → seek

- [ ] **Manual Testing:**
  - [ ] Test với real backend API
  - [ ] Verify audio plays smoothly
  - [ ] Test with/without headphones
  - [ ] Test offline mode (cached audio)

### Definition of Done

- [ ] ✅ Shadowing audio loads from backend (no mock data)
- [ ] ✅ Playback controls fully functional
- [ ] ✅ Headphone detection warning implemented
- [ ] ✅ Audio caching working
- [ ] ✅ Error states handled gracefully
- [ ] ✅ Unit + Widget tests passing
- [ ] ✅ Manual QA approved
- [ ] ✅ No new TODOs introduced

---

## WP-P2-002: Subscription Enforcement

**Owner:** Mobile Feature Developer  
**Duration:** 2 days  
**Priority:** 🔴 Critical  
**Audit IDs:** #7, #24

### Implementation Checklist

#### Day 1: Premium Content Gating

- [ ] **T001: Subscription Provider Enhancement**

  ```dart
  // lib/features/subscription/providers/subscription_provider.dart

  @riverpod
  class SubscriptionNotifier extends _$SubscriptionNotifier {
    @override
    Future<SubscriptionStatus> build() async {
      // Load from API instead of mock
      final repository = ref.read(subscriptionRepositoryProvider);
      final result = await repository.getCurrentSubscription();

      return result.fold(
        (error) {
          logger.error('Failed to load subscription', error: error);
          // Default to free on error
          return SubscriptionStatus.free();
        },
        (status) => status,
      );
    }

    bool hasAccessToContent(ContentType contentType) {
      final status = state.value;
      if (status == null) return false;

      return switch (contentType) {
        ContentType.shadowingBasic => true, // Free for all
        ContentType.shadowingAdvanced => status.isPremium,
        ContentType.wordAssociation => status.isPremium,
        ContentType.advancedTranslation => status.isPremium,
        _ => true,
      };
    }
  }

  // Convenience provider
  @riverpod
  bool hasContentAccess(HasContentAccessRef ref, ContentType contentType) {
    final notifier = ref.watch(subscriptionNotifierProvider.notifier);
    return notifier.hasAccessToContent(contentType);
  }
  ```

- [ ] **T002: Integrate Gating trong Shadowing Library**

  ```dart
  // lib/features/translation/screens/shadowing_library_screen.dart

  Widget _buildContentCard(ShadowingContent content) {
    final hasAccess = ref.watch(
      hasContentAccessProvider(ContentType.shadowingAdvanced),
    );

    final isLocked = content.isPremium && !hasAccess;

    return GestureDetector(
      onTap: () async {
        if (isLocked) {
          await _showUpgradeDialog();
          return;
        }

        // Navigate to player
        context.push('/shadowing/player', extra: content);
      },
      child: Stack(
        children: [
          // Content preview
          ContentPreviewCard(content: content),

          // Lock overlay
          if (isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 48, color: Colors.white),
                    const SizedBox(height: 8),
                    const Text(
                      'Premium Content',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _showUpgradeDialog,
                      child: const Text('Upgrade to Premium'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showUpgradeDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const UpgradeDialog(),
    );
  }
  ```

#### Day 2: Purchase Flow Integration

- [ ] **T003: Implement Purchase Flow (Skeleton)**

  ```dart
  // lib/features/subscription/services/purchase_service.dart

  class PurchaseService {
    // TODO: Integrate with in_app_purchase package
    Future<Either<AppError, PurchaseResult>> purchasePlan(
      SubscriptionPlan plan,
    ) async {
      try {
        // Skeleton implementation for now
        logger.info('Purchase initiated', data: {'plan': plan.name});

        // In production:
        // 1. Fetch product details from App Store/Play Store
        // 2. Initiate purchase flow
        // 3. Verify purchase with backend
        // 4. Update local subscription status

        // For now, simulate success after 2 seconds
        await Future.delayed(const Duration(seconds: 2));

        return Right(PurchaseResult.success(
          plan: plan,
          transactionId: 'mock_${DateTime.now().millisecondsSinceEpoch}',
        ));

      } catch (e, stackTrace) {
        logger.error('Purchase failed', error: e, stackTrace: stackTrace);
        return Left(UnknownError(
          'Purchase failed',
          userMessage: 'Could not complete purchase. Please try again',
          originalError: e,
        ));
      }
    }
  }
  ```

- [ ] **T004: Update Plans Screen**

  ```dart
  // lib/features/subscription/screens/plans_screen.dart

  Future<void> _handlePurchase(SubscriptionPlan plan) async {
    // Show loading
    setState(() => _isPurchasing = true);

    final purchaseService = ref.read(purchaseServiceProvider);
    final result = await purchaseService.purchasePlan(plan);

    setState(() => _isPurchasing = false);

    result.fold(
      (error) {
        errorHandler.handleError(error, context: context);
      },
      (purchase) {
        // Refresh subscription status
        ref.invalidate(subscriptionNotifierProvider);

        // Show success
        _showPurchaseSuccess(plan);
      },
    );
  }
  ```

### Definition of Done

- [ ] ✅ Premium content gated correctly
- [ ] ✅ Upgrade prompts shown to free users
- [ ] ✅ Purchase flow skeleton in place
- [ ] ✅ Subscription status syncs with backend
- [ ] ✅ Tests verify gating logic
- [ ] ✅ No revenue-impacting bugs

---

## WP-P2-003: TTS Integration

**Owner:** Mobile Integration Engineer  
**Duration:** 2 days  
**Priority:** 🟡 High  
**Audit IDs:** #8, #11, #27

### Implementation Checklist

#### Day 1: TTS Service Setup

- [ ] **T001: Choose TTS Strategy**

  ```dart
  // Two options:
  // Option A: Platform TTS (flutter_tts) - Free, offline capable
  // Option B: ElevenLabs API - High quality, requires network

  // Recommended: Start với Platform TTS, add ElevenLabs later
  ```

- [ ] **T002: Implement Platform TTS Service**

  ```dart
  // lib/core/services/tts_service.dart

  import 'package:flutter_tts/flutter_tts.dart';

  class TtsService {
    final FlutterTts _tts = FlutterTts();

    Future<void> initialize() async {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5); // Slow for learners
      await _tts.setPitch(1.0);

      _tts.setErrorHandler((msg) {
        logger.error('TTS error', error: msg);
      });
    }

    Future<void> speak(String text) async {
      try {
        await _tts.speak(text);
      } catch (e) {
        logger.error('TTS speak failed', error: e);
        throw MediaError('Text-to-speech failed', originalError: e);
      }
    }

    Future<void> stop() async {
      await _tts.stop();
    }

    Future<void> setSpeed(double speed) async {
      await _tts.setSpeechRate(speed);
    }
  }
  ```

#### Day 2: Integration with Translation Features

- [ ] **T003: Intent Translation TTS**

  ```dart
  // lib/features/translation/widgets/intent_result_sheet.dart

  Row(
    children: [
      IconButton(
        icon: const Icon(Icons.volume_up),
        onPressed: () async {
          final tts = ref.read(ttsServiceProvider);
          await tts.speak(translation.modelAnswer);
        },
      ),
      // ...
    ],
  )
  ```

- [ ] **T004: Vocabulary Pronunciation TTS**

  ```dart
  // lib/features/learning/presentation/screens/vocabulary_detail_screen.dart

  IconButton(
    icon: const Icon(Icons.volume_up),
    onPressed: () async {
      final tts = ref.read(ttsServiceProvider);
      await tts.speak(vocabulary.word);
    },
  )
  ```

### Definition of Done

- [ ] ✅ TTS service implemented and tested
- [ ] ✅ Intent translation speaks model answer
- [ ] ✅ Vocabulary pronunciation works
- [ ] ✅ Playback can be stopped/controlled
- [ ] ✅ Error handling for TTS failures

---

## Phase 2 Completion Checklist

### Validation

- [ ] **Feature Complete:**

  - [ ] Shadowing audio plays from backend
  - [ ] Premium content properly gated
  - [ ] TTS works trong key features

- [ ] **Quality:**

  - [ ] All new code reviewed
  - [ ] Tests passing (170+ tests)
  - [ ] No critical bugs

- [ ] **Metrics:**
  - [ ] TODO count: <40 (from 70)
  - [ ] Missing feature issues resolved: 12/25

---

# 🔒 Phase 3: Security & Production Prep (Days 15-19)

**Objective:** Harden security, prepare for production deployment

**Duration:** 5 days  
**Issues Addressed:** 10 (Audit IDs #15, #16, #57, #58, #59, etc.)

---

## WP-P3-001: Security Hardening

### T001: SSL Certificate Pinning

```dart
// lib/core/network/ssl_pinning.dart

class SslPinning {
  static SecurityContext getSecurityContext() {
    final context = SecurityContext.defaultContext;

    // Add certificate pins
    context.setTrustedCertificatesBytes(
      _loadCertificate('assets/certs/speakpal.pem'),
    );

    return context;
  }
}

// Update Dio client
final dio = Dio()
  ..httpClientAdapter = DefaultHttpClientAdapter()
    ..onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return _verifyCertificate(cert, host);
      };
      return client;
    };
```

### T002: Code Obfuscation Setup

```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=build/debug-info
flutter build ios --obfuscate --split-debug-info=build/debug-info
```

### T003: Secure Storage Verification

- Test secure storage trên Android API 21-23
- Implement fallback encryption if needed
- Verify tokens never logged

---

## WP-P3-002: CI/CD Pipeline

### T001: GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: bash <(curl -s https://codecov.io/bash)

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: flutter build apk --release

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - run: flutter build ios --release --no-codesign
```

---

## Phase 3 Deliverables

- [ ] SSL pinning enabled
- [ ] Code obfuscation configured
- [ ] CI/CD pipeline operational
- [ ] Security audit passed
- [ ] Production build successful

---

# ✨ Phase 4: Polish & Optimization (Days 20-25)

**Objective:** Resolve remaining medium/low priority issues, optimize performance

---

## Focus Areas

1. **Offline Mode:** Implement data persistence
2. **Network Resilience:** Retry logic, connectivity checks
3. **Performance:** Memory management, animation optimization
4. **Accessibility:** Screen reader support, semantic labels
5. **Documentation:** Update all TODO-removed areas

---

## Sample Work Packages

### WP-P4-001: Offline Mode

- Integrate Hive/Drift for local storage
- Implement sync logic
- Handle conflicts

### WP-P4-002: Network Resilience

- Add connectivity_plus
- Implement retry interceptor
- Queue offline requests

### WP-P4-003: Performance

- Profile audio memory usage
- Optimize animations
- Lazy load heavy screens

---

# 🎯 Phase 5: Final QA & Launch (Days 26-28)

## Deliverables

- [ ] Full regression testing
- [ ] Performance testing on low-end devices
- [ ] Security penetration testing
- [ ] User acceptance testing
- [ ] Production deployment
- [ ] Post-launch monitoring setup

---

**End of Phases 2-4 Plan**
