// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:mindful_dart_util/mindful_dart_util.dart';
import 'package:test/test.dart';

void main() {
  group('file', () {
    test("userHome gets the user's home", () {
      final home = userHome();
      if (Platform.isMacOS) {
        expect(home?.path, equals('/Users/mbushe'));
      } else {
        expect(home?.path, equals('/home/admin'));
      }
    });
    test('test expand path', () {
      expect(expandPath('./test'), equals('${Directory.current.path}/test'));
    });
  });
  group('date', () {
    test('today() is today', () {
      final libToday = today();
      final now = DateTime.now();
      expect(libToday.year, equals(now.year));
      expect(libToday.month, equals(now.month));
      expect(libToday.day, equals(now.day));
    });
    test('dateOneWeekAgo() is a week ago', () {
      final libdateOneWeekAgo = dateOneWeekAgo();
      final now = DateTime.now();
      expect(libdateOneWeekAgo.year, equals(now.year));
      expect(libdateOneWeekAgo.month, equals(now.month));
      expect(libdateOneWeekAgo.day, equals(now.day - 7));
    });
  });
}
