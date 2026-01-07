import 'package:flutter/material.dart';

class AiAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isSpeaking;

  const AiAvatar({
    Key? key,
    required this.name,
    this.avatarUrl,
    this.isSpeaking = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (isSpeaking)
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
              ),
            CircleAvatar(
              radius: 40,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isSpeaking)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Speaking...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
