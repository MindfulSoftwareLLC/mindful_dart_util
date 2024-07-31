import 'dart:io';

import 'package:mindful_dart_util/mindful_dart_util.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

// Custom class to mimic ProcessResult for testing
class TestProcessResult implements ProcessResult {
  @override
  final int pid;
  @override
  final int exitCode;
  @override
  final stdout;
  @override
  final stderr;

  TestProcessResult({
    this.pid = 0,
    required this.exitCode,
    this.stdout = '',
    this.stderr = '',
  });
}

void main() {
  group('executingScriptsDirectory', () {
    test('returns the correct directory', () {
      // Save the original values
      final originalScriptPath = Platform.script.toFilePath();
      final originalDirectory = Directory.current;

      try {
        // Set up a test environment
        final testDir = Directory.systemTemp.createTempSync('ls _');
        final testScriptPath = path.join(testDir.path, 'test_script.dart');
        File(testScriptPath).writeAsStringSync('void main() {}');

        // Change the current directory and set the DART_SCRIPT environment variable
        Directory.current = testDir;
        Platform.environment['DART_SCRIPT'] = testScriptPath;

        // Run the function and check the result
        final result = executingScriptsDirectory();
        expect(result.path, equals(testDir.path));
      } finally {
        // Restore the original values
        Platform.environment['DART_SCRIPT'] = originalScriptPath;
        Directory.current = originalDirectory;
      }
    }, skip: true);
  });

  group('runProcessSync', () {
    test('runs process and handles successful execution', () {
      final testResult = TestProcessResult(
        exitCode: 0,
        stdout: 'Success output',
        stderr: '',
      );

      ProcessResult testRunSync(String executable, List<String> args,
          {String? workingDirectory}) {
        return testResult;
      }

      IOOverrides.runZoned(() {
        runProcessSync(
          executable: 'ls ',
          arguments: ['.'],
          workingDir: '/test/dir',
          throwingError: 'Test error',
        );
      });
    }, skip: true);

    test('throws exception on non-zero exit code', () {
      final testResult = TestProcessResult(
        exitCode: 1,
        stdout: '',
        stderr: 'Error output',
      );

      ProcessResult testRunSync(String executable, List<String> args,
          {String? workingDirectory}) {
        return testResult;
      }

      expect(() {
        IOOverrides.runZoned(
          () {
            runProcessSync(
              executable: 'ls ',
              arguments: ['.'],
              workingDir: '/test/dir',
              throwingError: 'Test error',
            );
          },
        );
      }, throwsException);
    });

    test('does not throw exception on allowed non-zero exit code', () {
      final testResult = TestProcessResult(
        exitCode: 1,
        stdout: '',
        stderr: '',
      );

      ProcessResult testRunSync(String executable, List<String> args,
          {String? workingDirectory}) {
        return testResult;
      }

      IOOverrides.runZoned(
        () {
          runProcessSync(
            executable: 'ls ',
            arguments: ['.'],
            workingDir: '/test/dir',
            throwingError: 'Test error',
            okExits: [1, 2],
          );
        },
      );
    });
  }, skip: true);

  group('logAndThrowOnNon0Exit', () {
    test('does not throw on exit code 0', () {
      final testResult = TestProcessResult(
        exitCode: 0,
        stdout: 'Success output',
      );

      expect(() => logAndThrowOnNon0Exit(testResult, 'Test message'),
          returnsNormally);
    });

    test('throws on non-zero exit code', () {
      final testResult = TestProcessResult(
        exitCode: 1,
        stderr: 'Error output',
      );

      expect(() => logAndThrowOnNon0Exit(testResult, 'Test message'),
          throwsException);
    });

    test('does not throw on allowed non-zero exit code', () {
      final testResult = TestProcessResult(
        exitCode: 1,
        stdout: 'Output',
      );

      expect(() => logAndThrowOnNon0Exit(testResult, 'Test message', [1, 2]),
          returnsNormally);
    });
  });
}
