import 'dart:io';

import 'package:args/command_runner.dart';

/// Given a param name that accepts a file name as the following argument
/// return the text of the indicated file.
/// @throw UsageException if there's not token following the param
/// @throw FileSystemException if the indicated file does not exist.
Future<String> fileStringFromCli(
    {required String param,
    required String command,
    required List<String> args}) async {
  File devOpsConfigFile;
  final cliLibDevOpsConfigArgPosition = args.indexOf(param);
  if (args.length >= cliLibDevOpsConfigArgPosition + 1) {
    final message = '$command $param option requires a file.';
    throw UsageException(message, '--$param <file>');
  }
  if (cliLibDevOpsConfigArgPosition > -1 &&
      args.length >= cliLibDevOpsConfigArgPosition) {
    final filePath = args[cliLibDevOpsConfigArgPosition + 1];
    devOpsConfigFile = File(filePath);
    if (!devOpsConfigFile.existsSync()) {
      final message = "$command $filePath file doesn't exist.";
      throw FileSystemException(message);
    } else {
      return devOpsConfigFile.readAsString();
    }
  } else {
    throw UsageException('Check arguments.', '--$param <file>');
  }
}
