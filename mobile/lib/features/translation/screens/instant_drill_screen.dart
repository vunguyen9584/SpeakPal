import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InstantDrillScreen extends ConsumerStatefulWidget {
  const InstantDrillScreen({super.key});

  @override
  ConsumerState<InstantDrillScreen> createState() =>
      _InstantDrillScreenState();
}

class _InstantDrillScreenState extends ConsumerState<InstantDrillScreen> {
  int _currentQuestion = 0;
  final int _totalQuestions = 10;
  int _totalScore = 0;
  final List<int> _questionScores = [];

  final List<String> _mockQuestions = [
    'What is your name?',
    'Where are you from?',
    'What do you do for a living?',
    'What are your hobbies?',
    'What is your favorite food?',
    'How was your day?',
    'What time is it?',
    'Where is the nearest station?',
    'Can you help me?',
    'Thank you very much!',
  ];

  void _submitAnswer(int score) {
    setState(() {
      _questionScores.add(score);
      _totalScore += score;
      
      if (_currentQuestion < _totalQuestions - 1) {
        _currentQuestion++;
      } else {
        _showFinalResult();
      }
    });
  }

  void _showFinalResult() {
    final avgScore = _totalScore / _totalQuestions;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('完了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              avgScore.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const Text('平均スコア'),
            const SizedBox(height: 16),
            Text('合計: $_totalScore点'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentQuestion + 1) / _totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('瞬間応答ドリル'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            
            // Question counter
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '問題 ${_currentQuestion + 1}/$_totalQuestions',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'スコア: $_totalScore',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Question card
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.question_answer,
                            size: 64,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _mockQuestions[_currentQuestion],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 24),
                          IconButton(
                            onPressed: () {
                              // TODO: Play audio
                            },
                            icon: const Icon(Icons.volume_up, size: 48),
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Timer and answer button (mock)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '10秒',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Mock: random score
                        final score = 70 + (DateTime.now().millisecond % 30);
                        _submitAnswer(score);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        '回答する (デモ)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
