import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shadowing_models.dart';
import 'shadowing_player_screen.dart';

class ShadowingLibraryScreen extends ConsumerStatefulWidget {
  const ShadowingLibraryScreen({super.key});

  @override
  ConsumerState<ShadowingLibraryScreen> createState() =>
      _ShadowingLibraryScreenState();
}

class _ShadowingLibraryScreenState
    extends ConsumerState<ShadowingLibraryScreen> {
  ContentType? _selectedType;
  String? _selectedLevel;

  // Mock data - URLs will be provided by backend API
  final List<ShadowingContent> _mockContents = [
    const ShadowingContent(
      id: '1',
      title: 'Daily Conversation: At a Restaurant',
      type: 'conversation',
      level: 'beginner',
      durationSeconds: 90,
      audioUrl: '', // TODO: Replace with actual API data
      transcript: 'Hello, I would like to order...',
      isPremium: false,
    ),
    const ShadowingContent(
      id: '2',
      title: 'Business News: Tech Industry Update',
      type: 'news',
      level: 'advanced',
      durationSeconds: 180,
      audioUrl: '', // TODO: Replace with actual API data
      transcript: 'In today\'s tech news...',
      isPremium: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredContents = _mockContents.where((content) {
      if (_selectedType != null && content.type != _selectedType!.name) {
        return false;
      }
      if (_selectedLevel != null && content.level != _selectedLevel) {
        return false;
      }
      return true;
    }).toList();

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
                
                // Type filter
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('すべて'),
                      selected: _selectedType == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedType = null;
                        });
                      },
                    ),
                    ...ContentType.values.map((type) {
                      return FilterChip(
                        label: Text(type.displayName),
                        selected: _selectedType == type,
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = selected ? type : null;
                          });
                        },
                      );
                    }),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Level filter
                DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  decoration: const InputDecoration(
                    labelText: 'レベル',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('すべて')),
                    DropdownMenuItem(value: 'beginner', child: Text('初級')),
                    DropdownMenuItem(value: 'intermediate', child: Text('中級')),
                    DropdownMenuItem(value: 'advanced', child: Text('上級')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Content grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredContents.length,
              itemBuilder: (context, index) {
                final content = filteredContents[index];
                return _buildContentCard(content);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(ShadowingContent content) {
    final isLocked = content.isPremium; // TODO: Check subscription

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
                      _getContentIcon(content.type),
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
                              '${content.durationSeconds ~/ 60}:${(content.durationSeconds % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildLevelBadge(content.level),
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

  IconData _getContentIcon(String type) {
    switch (type) {
      case 'conversation':
        return Icons.chat;
      case 'news':
        return Icons.newspaper;
      case 'speech':
        return Icons.mic;
      case 'podcast':
        return Icons.podcasts;
      default:
        return Icons.audiotrack;
    }
  }

  Widget _buildLevelBadge(String level) {
    Color color;
    String label;
    switch (level) {
      case 'beginner':
        color = Colors.green;
        label = '初級';
        break;
      case 'intermediate':
        color = Colors.orange;
        label = '中級';
        break;
      case 'advanced':
        color = Colors.red;
        label = '上級';
        break;
      default:
        color = Colors.grey;
        label = level;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.shade900,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('プレミアムコンテンツ'),
        content: const Text('このコンテンツはプレミアム会員限定です。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to subscription screen
            },
            child: const Text('プレミアムに登録'),
          ),
        ],
      ),
    );
  }
}
