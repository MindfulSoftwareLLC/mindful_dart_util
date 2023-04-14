// ignore_for_file: avoid_print

import 'dart:io';

/// Runs an external process
void runProcess({
  required String executable,
  required List<String> arguments,
  required String workingDir,
  required String throwingError,
  List<int>? okExits,
}) {
  print('Running command:\n $executable ${arguments.toList()}');
  final process =
      Process.runSync(executable, arguments, workingDirectory: workingDir);
  stdout.write(process.stdout);
  stderr.write(process.stderr);
  logAndThrowOnNon0Exit(process, throwingError, okExits);
}

/// Logs the preocess result and throws if non-0
void logAndThrowOnNon0Exit(ProcessResult process, String message,
    [List<int>? okExits]) {
  final stdout = process.stdout;
  if (stdout is List) {
    stdout.forEach(print);
  } else {
    print(stdout);
  }
  if (process.exitCode != 0) {
    final messageWithExitCode = 'Exit ${process.exitCode}: $message';
    final stderr = process.stderr;
    if (stderr is List) {
      stderr.forEach(print);
    }
    if (okExits == null || !okExits.contains(process.exitCode)) {
      throw Exception(messageWithExitCode);
    }
  }
}
