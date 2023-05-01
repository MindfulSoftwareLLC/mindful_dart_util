import 'dart:io';

/// Returns the user's home directory or null if none specified.
Directory? userHome() {
  final homePath =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  if (homePath == null) {
    return null;
  } else {
    return Directory(homePath);
  }
}

/// Expand file paths starting with ~/ or ./ to absolute dirs
String expandPath(String rootDirName) {
  var fullPath = rootDirName;
  if (rootDirName.startsWith('~/')) {
    fullPath = '${userHome()}/${rootDirName.substring(2)}';
  } else if (rootDirName.startsWith('./')) {
    fullPath = '${Directory.current.path}/${rootDirName.substring(2)}';
  }
  return fullPath;
}

/// Ensure a directory exists
void ensureDir(String dirName) {
  final dir = Directory(dirName);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}
