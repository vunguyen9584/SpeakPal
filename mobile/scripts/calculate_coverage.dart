import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    print('coverage/lcov.info not found');
    return;
  }

  final lines = file.readAsLinesSync();
  int totalLines = 0;
  int coveredLines = 0;
  bool isGenerated = false;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      isGenerated = line.endsWith('.g.dart') || line.endsWith('.freezed.dart');
    } else if (!isGenerated && line.startsWith('LF:')) {
      totalLines += int.parse(line.substring(3));
    } else if (!isGenerated && line.startsWith('LH:')) {
      coveredLines += int.parse(line.substring(3));
    }
  }

  if (totalLines == 0) {
    print('No lines found');
  } else {
    final percentage = (coveredLines / totalLines * 100).toStringAsFixed(1);
    print('Total Lines: $totalLines');
    print('Covered Lines: $coveredLines');
    print('Coverage: $percentage%');
  }
}
