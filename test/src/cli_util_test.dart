import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mindful_dart_util/mindful_dart_util.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('fileStringFromCli', () {
    late Directory tempDir;
    late String tempFilePath;
    const testFileContent = 'Test file content';

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('test_');
      tempFilePath = path.join(tempDir.path, 'test_file.txt');
      await File(tempFilePath).writeAsString(testFileContent);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('returns file content when valid arguments are provided', () async {
      final result = await fileStringFromCli(
        param: '--config',
        command: 'test',
        args: ['--config', tempFilePath],
      );
      expect(result, equals(testFileContent));
    });

    test('throws UsageException when param is the last argument', () async {
      expect(
        () => fileStringFromCli(
          param: '--config',
          command: 'test',
          args: ['--config'],
        ),
        throwsA(isA<UsageException>().having(
          (e) => e.message,
          'message',
          'test --config option requires a file.',
        )),
      );
    });

    test('throws FileSystemException when file does not exist', () async {
      expect(
        () => fileStringFromCli(
          param: '--config',
          command: 'test',
          args: ['--config', 'non_existent_file.txt'],
        ),
        throwsA(isA<FileSystemException>().having(
          (e) => e.message,
          'message',
          "test non_existent_file.txt file doesn't exist.",
        )),
      );
    });

    test('throws UsageException when param is not found in args', () async {
      expect(
        () => fileStringFromCli(
          param: '--config',
          command: 'test',
          args: ['--other-param', 'value'],
        ),
        throwsA(isA<UsageException>().having(
          (e) => e.message,
          'message',
          'Check arguments.',
        )),
      );
    });

    test('works with different param names', () async {
      final result = await fileStringFromCli(
        param: '--custom-param',
        command: 'test',
        args: ['--custom-param', tempFilePath],
      );
      expect(result, equals(testFileContent));
    });

    test('works when param is not the first argument', () async {
      final result = await fileStringFromCli(
        param: '--config',
        command: 'test',
        args: ['--other-param', 'value', '--config', tempFilePath],
      );
      expect(result, equals(testFileContent));
    });
  });
}
