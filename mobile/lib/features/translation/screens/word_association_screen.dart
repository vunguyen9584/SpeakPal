import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class WordAssociationScreen extends ConsumerStatefulWidget {
  const WordAssociationScreen({super.key});

  @override
  ConsumerState<WordAssociationScreen> createState() =>
      _WordAssociationScreenState();
}

class _WordAssociationScreenState
    extends ConsumerState<WordAssociationScreen> {
  int _timeRemaining = 60;
  int _score = 0;
  int _chain = 0;
  double _multiplier = 1.0;
  String _currentKeyword = 'apple';
  bool _isPlaying = false;
  bool _showFeedback = false;
  bool _isCorrect = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _timeRemaining = 60;
      _score = 0;
      _chain = 0;
      _multiplier = 1.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
        if (_timeRemaining <= 0) {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
    
    // Show result dialog
    _showResultDialog();
  }

  void _onAnswerSubmitted(bool correct) {
    setState(() {
      _showFeedback = true;
      _isCorrect = correct;

      if (correct) {
        _chain++;
        if (_chain >= 5) {
          _multiplier = 2.0;
        } else if (_chain >= 3) {
          _multiplier = 1.5;
        }
        _score += (10 * _multiplier).round();
        
        // Change keyword
        _currentKeyword = _getNextKeyword();
      } else {
        _chain = 0;
        _multiplier = 1.0;
      }
    });

    // Hide feedback after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showFeedback = false;
        });
      }
    });
  }

  String _getNextKeyword() {
    // Mock implementation
    final keywords = ['fruit', 'color', 'animal', 'sport', 'music'];
    return keywords[DateTime.now().millisecond % keywords.length];
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('邨先棡'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Text('轤ｹ'),
            const SizedBox(height: 16),
            Text('譛螟ｧ繝√ぉ繧､繝ｳ: $_chain'),
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text('もう一度'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPlaying) {
      return Scaffold(
        appBar: AppBar(title: const Text('ワード連想')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.psychology, size: 100, color: Colors.purple),
              const SizedBox(height: 24),
              const Text(
                'ワード連想チャレンジ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '60秒間でキーワードに関連する単語を\nできるだけ多く答えよう！',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text('スタート', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('繝ｯ繝ｼ繝蛾｣諠ｳ'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header with timer, score, chain
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.purple.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        '時間',
                        '$_timeRemaining秒',
                        Icons.timer,
                        Colors.red,
                      ),
                      _buildStatCard(
                        'スコア',
                        '$_score',
                        Icons.star,
                        Colors.amber,
                      ),
                      _buildStatCard(
                        'チェイン',
                        'x${_multiplier.toStringAsFixed(1)}',
                        Icons.whatshot,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Keyword card
                Expanded(
                  child: Center(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: 300,
                        height: 200,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'キーワード',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _currentKeyword,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fadeIn().scale(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Mock answer buttons (for demo)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _onAnswerSubmitted(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text('正解 (デモ)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _onAnswerSubmitted(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text('不正解 (デモ)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Feedback overlay
          if (_showFeedback)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Icon(
                    _isCorrect ? Icons.check_circle : Icons.cancel,
                    size: 100,
                    color: _isCorrect ? Colors.green : Colors.red,
                  ).animate().scale(duration: 300.ms).then().fadeOut(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

