import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/theme/typography.dart';
import '../../../../config/theme/dimensions.dart';
import '../../../../shared/widgets/app_button.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import '../widgets/voice_selector.dart';
import '../widgets/personality_selector.dart';
import '../widgets/persona_card.dart';

/// Persona Setup Screen
class PersonaSetupScreen extends StatefulWidget {
  final Level selectedLevel;

  const PersonaSetupScreen({
    super.key,
    required this.selectedLevel,
  });

  @override
  State<PersonaSetupScreen> createState() => _PersonaSetupScreenState();
}

class _PersonaSetupScreenState extends State<PersonaSetupScreen> {
  final _nameController = TextEditingController(text: 'Alex');
  String? _selectedVoice = 'VOICE_1';
  String? _selectedPersonality = 'CHEERFUL';
  bool _showPreview = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a persona name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedVoice == null || _selectedPersonality == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select voice and personality'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Save persona to backend
    // For now, navigate to onboarding complete
    context.push('/onboarding/complete');
  }

  void _togglePreview() {
    setState(() {
      _showPreview = !_showPreview;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your AI Partner'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Create your AI conversation partner',
                style: AppTypography.h2,
              ),
              const SizedBox(height: 8),
              Text(
                'Customize your AI tutor\'s voice and personality',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Name Input
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Persona Name',
                  hintText: 'Enter a name for your AI partner',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // Voice Selector
              VoiceSelector(
                selectedVoice: _selectedVoice,
                onVoiceSelected: (voice) {
                  setState(() {
                    _selectedVoice = voice;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Personality Selector
              PersonalitySelector(
                selectedPersonality: _selectedPersonality,
                onPersonalitySelected: (personality) {
                  setState(() {
                    _selectedPersonality = personality;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Preview Button
              OutlinedButton.icon(
                onPressed: _togglePreview,
                icon: Icon(_showPreview ? Icons.visibility_off : Icons.visibility),
                label: Text(_showPreview ? 'Hide Preview' : 'Show Preview'),
              ),

              // Preview Card
              if (_showPreview) ...[
                const SizedBox(height: 16),
                PersonaCard(
                  name: _nameController.text.isNotEmpty
                      ? _nameController.text
                      : 'Your Persona',
                  voice: _selectedVoice ?? 'VOICE_1',
                  personality: _selectedPersonality ?? 'CHEERFUL',
                ),
              ],

              const SizedBox(height: 32),

              // Create Button
              AppButton(
                text: 'Create Persona',
                onPressed: _handleCreate,
                isFullWidth: true,
                size: ButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

