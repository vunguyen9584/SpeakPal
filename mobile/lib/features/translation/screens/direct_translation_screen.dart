import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/topic_provider.dart';
import '../providers/recording_provider.dart';
import '../widgets/translation_header.dart';
import '../widgets/question_card.dart';
import '../widgets/voice_recorder.dart';
// import '../widgets/translation_result_sheet.dart';

class DirectTranslationScreen extends ConsumerStatefulWidget {
  const DirectTranslationScreen({super.key});

  @override
  ConsumerState<DirectTranslationScreen> createState() =>
      _DirectTranslationScreenState();
}

class _DirectTranslationScreenState
    extends ConsumerState<DirectTranslationScreen> {
  // bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    // final topic = ref.watch(topicProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('翻訳練習'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with daily progress and topic selector
            const TranslationHeader(),
            
            // Question card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const QuestionCard(),
                    const SizedBox(height: 32),
                    
                    // Voice recorder button
                    const VoiceRecorder(),
                    
                    const SizedBox(height: 16),
                    
                    // Timer display
                    Consumer(
                      builder: (context, ref, child) {
                        final time = ref.watch(recordingTimeProvider);
                        return Text(
                          '${30 - time}s',
                          style: Theme.of(context).textTheme.headlineMedium,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showResultSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => const TranslationResultSheet(),
  //   );
  // }
}
