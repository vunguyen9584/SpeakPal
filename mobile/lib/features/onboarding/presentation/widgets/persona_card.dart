import 'package:flutter/material.dart';

/// Persona Card Widget - displays created persona
class PersonaCard extends StatelessWidget {
  final String name;
  final String voice;
  final String personality;

  const PersonaCard({
    super.key,
    required this.name,
    required this.voice,
    required this.personality,
  });

  String _getVoiceName(String voiceId) {
    switch (voiceId) {
      case 'VOICE_1':
        return 'Male US';
      case 'VOICE_2':
        return 'Female US';
      case 'VOICE_3':
        return 'Male UK';
      default:
        return voiceId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Center(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Details
            _buildDetailRow(Icons.record_voice_over, 'Voice', _getVoiceName(voice)),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.psychology, 'Personality', personality),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

