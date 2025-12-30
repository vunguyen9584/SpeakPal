import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/conversation.dart';

class ConversationSetupScreen extends ConsumerStatefulWidget {
  final ConversationMode? initialMode;

  const ConversationSetupScreen({Key? key, this.initialMode}) : super(key: key);

  @override
  ConsumerState<ConversationSetupScreen> createState() => _ConversationSetupScreenState();
}

class _ConversationSetupScreenState extends ConsumerState<ConversationSetupScreen> {
  late ConversationMode selectedMode;
  String? selectedTopic;
  String selectedPersonaId = 'default';

  @override
  void initState() {
    super.initState();
    selectedMode = widget.initialMode ?? ConversationMode.freetalk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Conversation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Mode', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildModeSelector(),
            const SizedBox(height: 24),
            Text('Select Topic (Optional)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildTopicSelector(),
            const SizedBox(height: 24),
            Text('AI Partner', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildPersonaSelector(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startConversation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Start Conversation'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Column(
      children: ConversationMode.values.map((mode) {
        return RadioListTile<ConversationMode>(
          title: Text(_getModeTitle(mode)),
          subtitle: Text(_getModeSubtitle(mode)),
          value: mode,
          groupValue: selectedMode,
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedMode = value);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildTopicSelector() {
    final topics = ['Daily Life', 'Travel', 'Business', 'Technology', 'Sports', 'Culture'];
    return Wrap(
      spacing: 8,
      children: topics.map((topic) {
        return FilterChip(
          label: Text(topic),
          selected: selectedTopic == topic,
          onSelected: (selected) {
            setState(() => selectedTopic = selected ? topic : null);
          },
        );
      }).toList(),
    );
  }

  Widget _buildPersonaSelector() {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Text('S')),
        title: const Text('Sarah'),
        subtitle: const Text('Friendly, Patient'),
        trailing: TextButton(
          onPressed: () {
            // TODO: Show persona selection dialog
          },
          child: const Text('Change Partner'),
        ),
      ),
    );
  }

  String _getModeTitle(ConversationMode mode) {
    switch (mode) {
      case ConversationMode.freetalk:
        return 'Free Talk';
      case ConversationMode.instructor:
        return 'Instructor';
      case ConversationMode.roleplay:
        return 'Roleplay';
    }
  }

  String _getModeSubtitle(ConversationMode mode) {
    switch (mode) {
      case ConversationMode.freetalk:
        return 'Practice freely';
      case ConversationMode.instructor:
        return 'With guidance';
      case ConversationMode.roleplay:
        return 'Real scenarios';
    }
  }

  Future<void> _startConversation() async {
    // TODO: Create conversation via repository
    // TODO: Navigate to conversation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting conversation...')),
    );
  }
}
