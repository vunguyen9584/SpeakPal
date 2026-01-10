import 'package:flutter/material.dart';
import '../../domain/models/conversation.dart';

class ModeSelector extends StatelessWidget {
  final ConversationMode selectedMode;
  final ValueChanged<ConversationMode> onModeChanged;

  const ModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ConversationMode.values.map((mode) {
        return RadioListTile<ConversationMode>(
          title: Text(_getModeTitle(mode)),
          subtitle: Text(_getModeSubtitle(mode)),
          value: mode,
          groupValue: selectedMode,
          onChanged: (value) {
            if (value != null) {
              onModeChanged(value);
            }
          },
        );
      }).toList(),
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
}
