import 'package:flutter/material.dart';

class EndConversationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const EndConversationDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => EndConversationDialog(
        onConfirm: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange),
          SizedBox(width: 12),
          Text('End Conversation?'),
        ],
      ),
      content: const Text(
        'Are you sure you want to end this conversation? '
        'Your progress will be saved and you\'ll see a summary.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('End'),
        ),
      ],
    );
  }
}
