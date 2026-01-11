import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/translation_provider.dart';
import 'shadowing_player_screen.dart';
import 'package:mobile/features/subscription/providers/subscription_provider.dart';
import 'package:mobile/features/subscription/widgets/upgrade_dialog.dart';

class ShadowingLibraryScreen extends ConsumerStatefulWidget {
  const ShadowingLibraryScreen({super.key});

  @override
  ConsumerState<ShadowingLibraryScreen> createState() =>
      _ShadowingLibraryScreenState();
}

class _ShadowingLibraryScreenState
    extends ConsumerState<ShadowingLibraryScreen> {
  TranslationTopic _selectedTopic = TranslationTopic.daily;
  Difficulty _selectedDifficulty = Difficulty.beginner;

  @override
  Widget build(BuildContext context) {
    final shadowingAsync = ref.watch(shadowingContentProvider(ShadowingParams(
      difficulty: _selectedDifficulty,
      topic: _selectedTopic,
    )));

    return Scaffold(
      appBar: AppBar(
        title: const Text('シャドーイング'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'フィルター',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Topic filter
                Wrap(
                  spacing: 8,
                  children: TranslationTopic.values.map((topic) {
                    return FilterChip(
                      label: Text(topic.displayName),
                      selected: _selectedTopic == topic,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedTopic = topic;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 8),
                
                // Level filter
                DropdownButtonFormField<Difficulty>(
                  initialValue: _selectedDifficulty,
                  decoration: const InputDecoration(
                    labelText: 'レベル',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: Difficulty.values.map((d) {
                    return DropdownMenuItem(
                      value: d,
                      child: Text(_getDifficultyLabel(d)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDifficulty = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Content list
          Expanded(
            child: shadowingAsync.when(
              data: (contents) => contents.isEmpty
                  ? const Center(child: Text('コンテンツが見つかりません'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: contents.length,
                      itemBuilder: (context, index) {
                        final content = contents[index];
                        return _buildContentCard(content);
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('エラーが発生しました: $err'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(shadowingContentProvider),
                      child: const Text('再試行'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(ShadowingContent content) {
    // Check if user has access to this content
    final hasAccess = ref.watch(
      hasContentAccessProvider(
        content.isPremium 
          ? ContentType.shadowingAdvanced 
          : ContentType.shadowingBasic
      ),
    );
    
    final isLocked = content.isPremium && !hasAccess;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: isLocked
            ? () {
                _showPremiumDialog();
              }
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShadowingPlayerScreen(content: content),
                  ),
                );
              },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                Container(
                  height: 100,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Icon(
                      _getTopicIcon(content.topic),
                      size: 48,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                
                // Content info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${content.duration.inMinutes}:${(content.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildDifficultyBadge(content.difficulty),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Lock overlay
            if (isLocked)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getTopicIcon(TranslationTopic topic) {
    switch (topic) {
      case TranslationTopic.daily:
        return Icons.chat;
      case TranslationTopic.business:
        return Icons.work;
      case TranslationTopic.travel:
        return Icons.flight;
      case TranslationTopic.news:
        return Icons.newspaper;
      case TranslationTopic.entertainment:
        return Icons.theater_comedy;
    }
  }

  String _getDifficultyLabel(Difficulty d) {
    switch (d) {
      case Difficulty.beginner:
        return '初級';
      case Difficulty.intermediate:
        return '中級';
      case Difficulty.advanced:
        return '上級';
    }
  }

  Widget _buildDifficultyBadge(Difficulty difficulty) {
    Color color;
    Color textColor;
    String label = _getDifficultyLabel(difficulty);
    switch (difficulty) {
      case Difficulty.beginner:
        color = Colors.green.shade100;
        textColor = Colors.green.shade900;
        break;
      case Difficulty.intermediate:
        color = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        break;
      case Difficulty.advanced:
        color = Colors.red.shade100;
        textColor = Colors.red.shade900;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => const UpgradeDialog(),
    );
  }
}

