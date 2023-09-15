import 'package:mindful_dart_util/mindful_dart_util.dart';

void main() {
  final home = userHome();
  // ignore: avoid_print
  print('home: ${home?.path}');
  // ignore: avoid_print
  print('executingScriptsDirectory: ${executingScriptsDirectory().path}');
}
