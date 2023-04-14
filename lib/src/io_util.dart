import 'dart:io';

void ensureDir(String dirName) {
  final file = File(dirName);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
}
