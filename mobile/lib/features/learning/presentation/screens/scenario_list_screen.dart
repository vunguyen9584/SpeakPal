import 'package:flutter/material.dart';
import '../../domain/models/scenario.dart';

class ScenarioListScreen extends StatefulWidget {
  const ScenarioListScreen({super.key});

  @override
  State<ScenarioListScreen> createState() => _ScenarioListScreenState();
}

class _ScenarioListScreenState extends State<ScenarioListScreen> {
  String _selectedCategory = 'All';
  String? _selectedDifficulty;

  final _categories = ['All', 'Daily', 'Business', 'Travel', 'Academic', 'Test Prep'];
  final _difficulties = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    // TODO: Use scenarioListProvider
    final scenarios = <Scenario>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scenarios'),
      ),
      body: Column(
        children: [
          // Category tabs
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Difficulty filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Difficulty:'),
                const SizedBox(width: 8),
                ..._difficulties.map((diff) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(diff),
                      selected: _selectedDifficulty == diff,
                      onSelected: (selected) {
                        setState(() {
                          _selectedDifficulty = selected ? diff : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Scenario list
          Expanded(
            child: scenarios.isEmpty
                ? const Center(child: Text('No scenarios available'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: scenarios.length,
                    itemBuilder: (context, index) {
                      return ScenarioCard(scenario: scenarios[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ScenarioCard extends StatelessWidget {
  final Scenario scenario;

  const ScenarioCard({super.key, required this.scenario});

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to conversation with scenario
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      scenario.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(scenario.difficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      scenario.difficulty,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                scenario.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text('${scenario.estimatedMinutes} min'),
                  const SizedBox(width: 16),
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 4),
                  Text(scenario.category),
                ],
              ),
              if (scenario.suggestedTopics.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: scenario.suggestedTopics.take(3).map((topic) {
                    return Chip(
                      label: Text(topic, style: const TextStyle(fontSize: 12)),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

