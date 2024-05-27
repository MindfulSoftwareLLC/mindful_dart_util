// ignore_for_file: omit_local_variable_types

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart' show sha256;
import 'package:io/io.dart';

/// @return true if file1's file size and SHA256 checksum is same as file2's.
Future<bool> areFilesIdentical(File file1, File file2) async {
  if (await areFilesOfEqualSize(file1, file2)) {
    final hash1 = await computeSHA256Checksum(file1);
    final hash2 = await computeSHA256Checksum(file2);
    return hash1 == hash2;
  }
  return false;
}

/// @return true if file1's File.stat().size is the same as file2's.
Future<bool> areFilesOfEqualSize(File file1, File file2) async {
  final file1Stat = await file1.stat();
  final file2Stat = await file2.stat();
  return file1Stat.size == file2Stat.size;
}

/// @return true if file1's SHA256 checksum is the same as file2's.
Future<String> computeSHA256Checksum(File file) async {
  final hash = await file.openRead().transform(sha256).join();
  return hash;
}

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

///Copy a source directory to a destination with the
Future<void> deepCopyDirectory(
    String sourceDirPath, String destinationDirPath) async {
  final source = Directory(sourceDirPath);
  if (!source.existsSync()) {
    throw Exception('Source directory does not exist: ${source.absolute.path}');
  }
  return copyPath(sourceDirPath, destinationDirPath);
}

Future<void> saveResults(
    Map<String, List<String>> duplicates, String filePath) async {
  final file = File(filePath);
  await file.writeAsString(json.encode(duplicates));
}

// Callback function types
typedef OnDupCheckStartedCallback = void Function(File file);
typedef DupFoundCallback = void Function(File originalFile, File duplicateFile);
typedef NoDuplicateCallback = void Function(File file);

Future<Map<File, List<File>>> findDuplicateFilesWithSave(
    Directory directory,
    OnDupCheckStartedCallback onDupCheckStartedCallback,
    DupFoundCallback matchFoundCallback,
    NoDuplicateCallback noDuplicateCallback) async {
  final Map<File, List<File>> duplicates = {};
  final Map<String, String> fileChecksums =
      {}; // Map to store file paths and their checksums
  final List<File> files = await directory
      .list(recursive: true, followLinks: false)
      .where((entity) => entity is File)
      .cast<File>()
      .toList();

  // First, compute checksums for all files to avoid recomputation.
  await Future.wait(files.map((file) async {
    final checksum = await computeSHA256Checksum(file);
    fileChecksums[file.absolute.path] = checksum;
  }));

  // This map will keep track of files that have already been compared to avoid redundant checks.
  final Map<String, bool> checkedFiles = {};

  for (final file1 in files) {
    onDupCheckStartedCallback(file1);
    var dupFound = false;
    final String key = file1.absolute.path;
    if (checkedFiles.containsKey(key)) {
      // Skip if already compared.
      continue;
    }
    // Mark the file as checked.
    checkedFiles[key] = true;

    for (final file2 in files) {
      if (file1 == file2 || checkedFiles.containsKey(file2.absolute.path)) {
        // Skip if it's the same file or if the second file has already been checked.
        continue;
      }

      //print('Checking: ${file2.absolute.path}');
      if (await areFilesIdentical(file1, file2)) {
        // If they are identical, add them to the duplicates map.
        duplicates[file1] = (duplicates[file1] ?? [])..add(file2);
        // Mark the duplicate file as checked.
        checkedFiles[file2.absolute.path] = true;
        dupFound = true;
        matchFoundCallback(file1, file2);
      }
    }
    if (!dupFound) {
      noDuplicateCallback(file1);
    }
  }

  // Filter out entries with no duplicates
  final Map<File, List<File>> actualDuplicates = {};
  duplicates.forEach((key, value) {
    if (value.isNotEmpty) {
      actualDuplicates[key] = value;
    }
  });

  return actualDuplicates;
}

Iterable<List<T>> partition<T>(List<T> list, int size) {
  return Iterable.generate(
    (list.length + size - 1) ~/ size,
    (index) => list.sublist(
      index * size,
      (index + 1) * size > list.length ? list.length : (index + 1) * size,
    ),
  );
}

Future<Map<File, List<File>>> findDuplicateFiles(
    Directory directory,
    String jsonResultPath,
    OnDupCheckStartedCallback onDupCheckStartedCallback,
    DupFoundCallback matchFoundCallback,
    NoDuplicateCallback onNoDuplicate) async {
  final Map<String, List<File>> potentialDuplicatesByChecksum = {};
  final Map<File, String> checksumsByFile =
      {}; // Map for storing file checksums
  final Map<int, List<File>> filesBySize =
      {}; // Map for grouping files by their size

  // Group files by size
  await for (final file
      in directory.list(recursive: true, followLinks: false)) {
    if (file is File) {
      final size = await file.length();
      filesBySize.putIfAbsent(size, () => []).add(file);
    }
  }

  // Filter out unique sizes and compute checksums for potential duplicates
  final candidates = filesBySize.values.where((list) => list.length > 1);
  for (final fileList in candidates) {
    for (final file in fileList) {
      print('computing SHA256Checksum for ${file.absolute.path}');
      final checksum = await computeSHA256Checksum(file);
      checksumsByFile[file] = checksum;
      potentialDuplicatesByChecksum[checksum] =
          (potentialDuplicatesByChecksum[checksum] ?? [])..add(file);
    }
  }

  final Map<File, List<File>> duplicates = {};
  final checkedFiles = <String>{};

  for (final fileList in candidates) {
    await Future.wait(fileList.map((file1) async {
      if (checkedFiles.contains(file1.absolute.path)) {
        return; // Skip files that have already been checked.
      }
      checkedFiles.add(file1.absolute.path);

      bool foundDuplicate = false;
      final file1Checksum = checksumsByFile[file1];
      for (final File file2
          in potentialDuplicatesByChecksum[file1Checksum] ?? []) {
        if (file2.absolute.path == file1.absolute.path)
          continue; // Skip comparing file to itself.

        if (file1Checksum == checksumsByFile[file2]) {
          foundDuplicate = true;
          duplicates[file1] = (duplicates[file1] ?? <File>[])..add(file2);

          // Call the match found callback
          matchFoundCallback(file1, file2);
        }
      }

      if (!foundDuplicate) {
        // Call the no duplicate callback
        onNoDuplicate(file1);
      }
    }), eagerError: true);
  }
  return duplicates;

  /*
  * ///////////
      onDupCheckStartedCallback(file1);
          matchFoundCallback(file1, file2);
          matchFoundForFile1 = true;
        }
      }
      if (!matchFoundForFile1) {
        noDuplicateCallback(file1);
      }
    }));

    // Periodically save results to avoid losing progress
    await saveResults(duplicates, '$jsonResultPath-temp');
  }

  */
  // Here, implement your logic to handle the 'duplicates' map as required.
}
