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
