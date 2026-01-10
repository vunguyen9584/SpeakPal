import 'package:flutter/material.dart';
import '../../domain/models/turn.dart';

class ChatBubble extends StatelessWidget {
  final Turn turn;
  final VoidCallback? onTap;

  const ChatBubble({
    super.key,
    required this.turn,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAI = turn.speaker == TurnSpeaker.ai;
    final hasCorrections = turn.corrections != null && turn.corrections!.isNotEmpty;

    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: GestureDetector(
        onTap: hasCorrections ? onTap : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isAI ? Colors.grey[200] : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                turn.content,
                style: TextStyle(
                  color: isAI ? Colors.black : Colors.white,
                  fontSize: 16,
                ),
              ),
              if (hasCorrections) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 14,
                      color: isAI ? Colors.orange : Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${turn.corrections!.length} correction${turn.corrections!.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isAI ? Colors.orange : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
