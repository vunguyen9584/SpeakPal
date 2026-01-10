import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/turn.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ConversationScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final List<Turn> _turns = [];
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  final bool _isAiSpeaking = false;
  final String _currentSubtitle = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showEndDialog(),
        ),
        title: Text(_formatDuration(Duration.zero)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          // AI Avatar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 8),
                const Text('Sarah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (_isAiSpeaking)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Speaking...', style: TextStyle(color: Colors.grey)),
                  ),
              ],
            ),
          ),
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _turns.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_turns[index]);
              },
            ),
          ),
          // Real-time Subtitle Box
          if (_currentSubtitle.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Text(
                _currentSubtitle,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          // Mic Button
          Container(
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
              onTapDown: (_) => _startRecording(),
              onTapUp: (_) => _stopRecording(),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? Colors.red : Theme.of(context).colorScheme.primary,
                ),
                child: Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Turn turn) {
    final isAi = turn.speaker == TurnSpeaker.ai;
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isAi ? Colors.grey[200] : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          turn.content,
          style: TextStyle(
            color: isAi ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  void _startRecording() {
    setState(() => _isRecording = true);
    // TODO: Start audio recording
  }

  void _stopRecording() {
    setState(() => _isRecording = false);
    // TODO: Stop audio recording and send via WebSocket
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Conversation?'),
        content: const Text('Are you sure you want to end this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _endConversation();
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('AI Speaking Speed'),
              trailing: DropdownButton<String>(
                value: 'normal',
                items: ['slow', 'normal', 'fast']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {},
              ),
            ),
            SwitchListTile(
              title: const Text('Show Real-time Corrections'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _endConversation() async {
    // TODO: End conversation via repository
    // TODO: Navigate to summary screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
