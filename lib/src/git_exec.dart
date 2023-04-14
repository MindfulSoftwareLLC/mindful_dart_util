// ignore_for_file: avoid_print

import 'dart:io';

import 'exec_util.dart';

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
    workingDir: '${rootDir.absolute.path}${Platform.pathSeparator}$repoSubDir',
  );
}

void createBranch({
  required String branchName,
  required String workingDir,
}) {
  runProcess(
      executable: 'git',
      arguments: ['checkout', '-b', branchName],
      workingDir: workingDir,
      throwingError: 'Error creating branch $branchName in dir: $workingDir',
      okExits: [128]);

  ///128 - branch exists
}

void cloneRepo({
  required String repo,
  required Directory workingDir,
  String? outDirName,
}) {
  final path = workingDir.absolute.path;
  print('(p)Cloning into $path');
  final targetPath = workingDir.absolute.path;
  print('(p)Cloning into $targetPath');
  final args = ['clone', repo];
  if (outDirName != null && outDirName.isNotEmpty) {
    args.add(outDirName);
  }
  runProcess(
    executable: 'git',
    arguments: args,
    workingDir: workingDir.absolute.path,
    throwingError:
        'Error cloning repo $repo into working directory $targetPath',
  );
}
