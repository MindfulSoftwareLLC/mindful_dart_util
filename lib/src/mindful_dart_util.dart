import 'dart:io';

import 'package:mindful_dart_util/mindful_dart_util.dart';

/// Utilities that only depend on Dart.
class MindfulDartUtil {
  static Directory? getHome() {
    return userHome();
  }
}
