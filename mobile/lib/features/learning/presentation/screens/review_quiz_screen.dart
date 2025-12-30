import 'package:flutter/material.dart';
import '../../domain/models/vocabulary.dart';

class ReviewQuizScreen extends StatefulWidget {
  final List<Vocabulary> vocabularies;

  const ReviewQuizScreen({Key? key, required this.vocabularies}) : super(key: key);

  @override
  State<ReviewQuizScreen> createState() => _ReviewQuizScreenState();
}

class _ReviewQuizScreenState extends State<ReviewQuizScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  int _correctCount = 0;

  Vocabulary get _currentVocab => widget.vocabularies[_currentIndex];

  @override
  Widget build(BuildContext context) {
    final progress = _currentIndex + 1;
    final total = widget.vocabularies.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review ($progress/$total)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showExitDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress / total,
            minHeight: 8,
          ),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FlashcardWidget(
                  vocabulary: _currentVocab,
                  showAnswer: _showAnswer,
                  onFlip: () {
                    setState(() {
                      _showAnswer = !_showAnswer;
                    });
                  },
                ),
              ),
            ),
          ),

          // Action buttons
          if (_showAnswer) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _recordAnswer(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Incorrect'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _recordAnswer(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Correct'),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAnswer = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Show Answer'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _recordAnswer(bool correct) {
    if (correct) _correctCount++;

    // TODO: Record review result to backend

    if (_currentIndex < widget.vocabularies.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      _showSummary();
    }
  }

  void _showSummary() {
    final percentage = (_correctCount / widget.vocabularies.length * 100).toInt();
    final xpEarned = _correctCount * 5 + (widget.vocabularies.length - _correctCount);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Review Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$percentage%',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text('$_correctCount/${widget.vocabularies.length} correct'),
            const SizedBox(height: 16),
            Text('+$xpEarned XP earned'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Review?'),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class FlashcardWidget extends StatelessWidget {
  final Vocabulary vocabulary;
  final bool showAnswer;
  final VoidCallback onFlip;

  const FlashcardWidget({
    Key? key,
    required this.vocabulary,
    required this.showAnswer,
    required this.onFlip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: Card(
        elevation: 8,
        child: Container(
          width: double.infinity,
          height: 300,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!showAnswer) ...[
                Text(
                  vocabulary.word,
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  vocabulary.pronunciation,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ] else ...[
                Text(
                  vocabulary.meaning,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (vocabulary.exampleSentence != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    vocabulary.exampleSentence!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
