import 'package:flutter/material.dart';

class ConversationSettingsSheet extends StatefulWidget {
  final double aiSpeed;
  final bool showRealTimeCorrections;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<bool> onCorrectionsToggled;

  const ConversationSettingsSheet({
    super.key,
    required this.aiSpeed,
    required this.showRealTimeCorrections,
    required this.onSpeedChanged,
    required this.onCorrectionsToggled,
  });

  static void show(
    BuildContext context, {
    required double aiSpeed,
    required bool showRealTimeCorrections,
    required ValueChanged<double> onSpeedChanged,
    required ValueChanged<bool> onCorrectionsToggled,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ConversationSettingsSheet(
        aiSpeed: aiSpeed,
        showRealTimeCorrections: showRealTimeCorrections,
        onSpeedChanged: onSpeedChanged,
        onCorrectionsToggled: onCorrectionsToggled,
      ),
    );
  }

  @override
  State<ConversationSettingsSheet> createState() => _ConversationSettingsSheetState();
}

class _ConversationSettingsSheetState extends State<ConversationSettingsSheet> {
  late double _currentSpeed;
  late bool _showCorrections;

  @override
  void initState() {
    super.initState();
    _currentSpeed = widget.aiSpeed;
    _showCorrections = widget.showRealTimeCorrections;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          const Text(
            'Conversation Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // AI Speaking Speed
          const Text(
            'AI Speaking Speed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Slow'),
              Expanded(
                child: Slider(
                  value: _currentSpeed,
                  min: 0.5,
                  max: 1.5,
                  divisions: 4,
                  label: _getSpeedLabel(_currentSpeed),
                  onChanged: (value) {
                    setState(() => _currentSpeed = value);
                    widget.onSpeedChanged(value);
                  },
                ),
              ),
              const Text('Fast'),
            ],
          ),
          const SizedBox(height: 16),
          // Real-time Corrections Toggle
          SwitchListTile(
            title: const Text('Show Real-time Corrections'),
            subtitle: const Text('Display corrections as they appear'),
            value: _showCorrections,
            onChanged: (value) {
              setState(() => _showCorrections = value);
              widget.onCorrectionsToggled(value);
            },
          ),
          const SizedBox(height: 16),
          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  String _getSpeedLabel(double speed) {
    if (speed <= 0.7) return 'Slow';
    if (speed <= 0.9) return 'Slower';
    if (speed <= 1.1) return 'Normal';
    if (speed <= 1.3) return 'Faster';
    return 'Fast';
  }
}
