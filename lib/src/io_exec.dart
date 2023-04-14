import 'dart:io';

void createDirMoveOld(Directory rootDir) {
  final dirPath = rootDir.absolute.path;
  if (rootDir.existsSync()) {
    var i = 0;
    var renamedDir = '';
    do {
      i++;
      renamedDir = '$dirPath-$i';
    } while (Directory(renamedDir).existsSync());
    final msg = 'Target directory exists, renaming to: $renamedDir';
    // ignore: avoid_print
    print(msg);
    rootDir.renameSync(renamedDir);
  }
  final message = 'Creating directory $dirPath';
  // ignore: avoid_print
  print(message);
  Directory(dirPath).createSync(recursive: true);
}
