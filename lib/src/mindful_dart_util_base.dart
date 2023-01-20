import 'dart:io';

/// Utilities that only depend on Dart.

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

String expandPath(String rootDirName) {
  var fullPath = rootDirName;
  if (rootDirName.startsWith('~/')) {
    fullPath = '${userHome()}/${rootDirName.substring(2)}';
  } else if (rootDirName.startsWith('./')) {
    fullPath = '${Directory.current.path}/${rootDirName.substring(2)}';
  }
  return fullPath;
}

/// Today's date
DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// The date 7 days ago
DateTime dateOneWeekAgo() {
  return today().subtract(const Duration(days: 7));
}
