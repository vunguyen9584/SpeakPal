import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart clean_log.dart <filename>');
    return;
  }
  final file = File(args[0]);
  if (!file.existsSync()) {
    print('File not found: ${args[0]}');
    return;
  }
  final bytes = file.readAsBytesSync();
  final result = StringBuffer();
  for (final byte in bytes) {
    if ((byte >= 32 && byte <= 126) || byte == 10 || byte == 13 || byte == 9) {
      result.write(String.fromCharCode(byte));
    }
  }
  print(result.toString());
}
