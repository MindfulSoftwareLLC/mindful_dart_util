// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:mindful_dart_util/mindful_dart_util.dart';
import 'package:test/test.dart';

void main() {
  group('MindfulDartUtil', () {
    test("userHome gets the user's home", () {
      var home = userHome();
      if (Platform.isMacOS) {
        expect(home?.path, equals('/Users/mbushe'));
      } else {
        expect(home?.path, equals('/home/admin'));
      }
    });
  });
}
