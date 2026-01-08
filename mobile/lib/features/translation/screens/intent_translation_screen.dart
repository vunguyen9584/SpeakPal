import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/intent_category.dart';
import '../models/intent_question.dart';
import '../widgets/voice_recorder.dart';
import '../widgets/intent_result_sheet.dart';

class IntentTranslationScreen extends ConsumerStatefulWidget {
  const IntentTranslationScreen({super.key});

  @override
  ConsumerState<IntentTranslationScreen> createState() =>
      _IntentTranslationScreenState();
}

class _IntentTranslationScreenState
    extends ConsumerState<IntentTranslationScreen> {
  IntentCategory _selectedCategory = IntentCategory.greeting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('意図翻訳練習'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Level restriction banner
              _buildLevelRestrictionBanner(),
              
              const SizedBox(height: 16),
              
              // Category selector
              _buildCategorySelector(),
              
              const SizedBox(height: 24),
              
              // Intent card
              _buildIntentCard(),
              
              const SizedBox(height: 32),
              
              // Voice recorder (reused)
              const VoiceRecorder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelRestrictionBanner() {
    // TODO: Check user level
    final isBeginnerUser = false;

    if (!isBeginnerUser) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, color: Colors.orange.shade900),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'この機能は中級以上のユーザーのみ利用できます',
              style: TextStyle(color: Colors.orange.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'カテゴリー',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: IntentCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category.icon, size: 16),
                  const SizedBox(width: 4),
                  Text(category.displayName),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIntentCard() {
    // TODO: Fetch actual question
    final mockQuestion = IntentQuestion(
      id: '1',
      situation: 'レストランで注文したい料理が売り切れだった',
      intent: '別のおすすめ料理を尋ねる',
      category: 'daily',
      difficulty: 'intermediate',
      hint: 'recommend, instead などを使うと良いでしょう',
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'シチュエーション',
                    style: TextStyle(
                      color: Colors.purple.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                _buildDifficultyBadge(mockQuestion.difficulty),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Situation
            Text(
              mockQuestion.situation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Intent
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mockQuestion.intent,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Hint (optional)
            if (mockQuestion.hint != null) ...[
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text('ヒント'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(mockQuestion.hint!),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        color = Colors.green;
        break;
      case 'intermediate':
        color = Colors.orange;
        break;
      case 'advanced':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color.shade900,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
