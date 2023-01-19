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

/// TODO: Remove me.  Testing lib exposure.
class MindfulDartUtil {
  static Directory? getHome() {
    return userHome();
  }
}
