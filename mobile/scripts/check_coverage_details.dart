import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    print('coverage/lcov.info not found');
    return;
  }

  final lines = file.readAsLinesSync();
  final fileStats = <String, Map<String, int>>{};
  String? currentFile;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3);
      if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) {
        currentFile = null;
        continue;
      }
      currentFile = path;
      fileStats[currentFile!] = {'hit': 0, 'found': 0};
    } else if (line.startsWith('LH:')) {
      if (currentFile != null) {
        fileStats[currentFile]!['hit'] = int.parse(line.substring(3));
      }
    } else if (line.startsWith('LF:')) {
      if (currentFile != null) {
        fileStats[currentFile]!['found'] = int.parse(line.substring(3));
      }
    }
  }

  final sortedFiles = fileStats.entries.toList()
    ..sort((a, b) {
      // Sort by number of uncovered lines (descending)
      final aUncovered = a.value['found']! - a.value['hit']!;
      final bUncovered = b.value['found']! - b.value['hit']!;
      return bUncovered.compareTo(aUncovered);
    });

  print('Top 20 files with missing coverage:');
  print('--------------------------------------------------');
  for (var i = 0; i < 20 && i < sortedFiles.length; i++) {
    final entry = sortedFiles[i];
    final found = entry.value['found']!;
    final hit = entry.value['hit']!;
    final uncovered = found - hit;
    final percentage = found > 0 ? (hit / found * 100).toStringAsFixed(1) : '0.0';
    
    // Shorten path for display
    final shortPath = entry.key.replaceAll(RegExp(r'.*lib[\\/]'), '');
    
    print('$shortPath');
    print('  Coverage: $percentage% ($hit/$found lines) - Missing: $uncovered lines');
  }
}
