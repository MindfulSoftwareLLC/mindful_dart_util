// ignore_for_file: avoid_print

import 'dart:io';

import 'package:mindful_dart_util/src/exec_util.dart';

/// Init a git repo
void initAndBranch({
  required Directory rootDir,
  required String branchName,
}) {
  initRepo(
    workingDir: rootDir,
  );
  createBranch(
    branchName: branchName,
    workingDir: rootDir,
  );
}

/// Clone a git repo
void cloneAndBranch({
  required String repo,
  required Directory rootDir,
  required String repoSubDir,
  required String branchName,
}) {
  cloneRepo(
    repo: repo,
    workingDir: rootDir,
    outDirName: repoSubDir,
  );
  createBranch(
    branchName: branchName,
    workingDir: Directory(
        '${rootDir.absolute.path}${Platform.pathSeparator}$repoSubDir'),
  );
}

/// Create a git branch
void createBranch({
  required String branchName,
  required Directory workingDir,
}) {
  print('Creating branch $branchName at $workingDir');
  runProcessSync(
      executable: 'git',
      arguments: ['checkout', '-b', branchName],
      workingDir: workingDir.absolute.path,
      throwingError: 'Error creating branch $branchName in dir: $workingDir',
      okExits: [128]);

  ///128 - branch exists
}

/// Init a git repo
void initRepo({
  required Directory workingDir,
}) {
  final path = workingDir.absolute.path;
  print('Initializing git repo at $path');
  runProcessSync(
    executable: 'git',
    arguments: ['init'],
    workingDir: workingDir.absolute.path,
    throwingError: 'Error initializing repo in working directory $path',
  );
}

/// Init a git repo
void addRemoteToRepo({
  required Directory workingDir,
  required String remoteUrl,
  String remoteName = 'origin',
}) {
  final path = workingDir.absolute.path;
  print('(p)Cloning into $path');
  runProcessSync(
    executable: 'git',
    arguments: ['remote', 'add', remoteName, remoteUrl],
    workingDir: workingDir.absolute.path,
    throwingError: 'Error adding remote to repo in working directory $path',
  );
}

/// Clone a git repo
void cloneRepo({
  required String repo,
  required Directory workingDir,
  String? outDirName,
}) {
  final path = workingDir.absolute.path;
  print('(p)Cloning into $path');
  final targetPath = workingDir.absolute.path;
  if (outDirName == null) {
    print('(p)Cloning into $targetPath');
  } else {
    print('(p)Cloning into $targetPath/$outDirName');
  }
  final args = ['clone', repo];
  if (outDirName != null && outDirName.isNotEmpty) {
    args.add(outDirName);
  }
  runProcessSync(
    executable: 'git',
    arguments: args,
    workingDir: workingDir.absolute.path,
    throwingError:
        'Error cloning repo $repo into working directory $targetPath',
  );
}
