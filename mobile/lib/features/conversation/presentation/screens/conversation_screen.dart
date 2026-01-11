import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/turn.dart';
import '../../../translation/providers/recording_provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/conversation_providers.dart';
import '../../../../core/network/socket_client.dart';

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
  bool _isAiSpeaking = false;
  String _currentSubtitle = '';
  SocketClient? _socketClient;

  @override
  void initState() {
    super.initState();
    _setupSocket();
  }

  Future<void> _setupSocket() async {
    _socketClient = ref.read(socketClientProvider);
    await _socketClient?.connect();
    
    if (mounted) {
       _socketClient?.joinConversation(widget.conversationId);
       _setupSocketListeners();
    }
  }

  void _setupSocketListeners() {
    _socketClient?.onTranscription((data) {
      if (mounted) {
        setState(() {
          _currentSubtitle = data['text'] ?? '';
        });
      }
    });

    _socketClient?.onTurnComplete((data) {
      if (mounted) {
        setState(() {
          _currentSubtitle = '';
          _turns.add(Turn.fromJson(data));
          _scrollToBottom();
        });
      }
    });

    _socketClient?.onAiResponseChunk((data) {
       // Handle audio stream or text chunk if needed
       if (mounted) {
         setState(() {
           _isAiSpeaking = true;
         });
       }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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

  Future<void> _startRecording() async {
    final recordingNotifier = ref.read(recordingProvider.notifier);
    await recordingNotifier.startRecording();
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    final recordingNotifier = ref.read(recordingProvider.notifier);
    final audioData = await recordingNotifier.stopRecording();
    setState(() => _isRecording = false);
    
    if (audioData != null) {
      _socketClient?.sendAudioChunk(audioData.toList()); // Convert Uint8List to List<int>
    }
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
    // Navigate to summary screen
    context.push('/conversation/${widget.conversationId}/summary');
  }

  @override
  void dispose() {
    _socketClient?.leaveConversation(widget.conversationId);
    _socketClient?.disconnect();
    _scrollController.dispose();
    super.dispose();
  }
}

