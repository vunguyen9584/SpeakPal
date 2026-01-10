import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/theme/typography.dart';
import '../../../../config/theme/dimensions.dart';
import '../../../../shared/widgets/app_button.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import '../widgets/level_card.dart';

/// Level Selection Screen
class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  Level? _selectedLevel;

  void _handleContinue() {
    if (_selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your English level'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to persona setup with selected level
    context.push('/onboarding/persona-setup', extra: _selectedLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Level'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s your English level?',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the level that best describes your current ability',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Level Cards List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLg,
                ),
                itemCount: Level.values.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final level = Level.values[index];
                  return LevelCard(
                    level: level,
                    isSelected: _selectedLevel == level,
                    onTap: () {
                      setState(() {
                        _selectedLevel = level;
                      });
                    },
                  );
                },
              ),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: AppButton(
                text: 'Continue',
                onPressed: _handleContinue,
                isFullWidth: true,
                size: ButtonSize.large,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

