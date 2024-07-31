import 'package:clock/clock.dart';
import 'package:mindful_dart_util/mindful_dart_util.dart';
import 'package:test/test.dart';

void main() {
  group('Date utility functions', () {
    test('today() returns the current date without time', () {
      final now = DateTime(2024, 7, 31, 15, 30, 45); // Arbitrary date and time
      withClock(Clock.fixed(now), () {
        final result = today();
        expect(result.year, equals(now.year));
        expect(result.month, equals(now.month));
        expect(result.day, equals(now.day));
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
      });
    });

    test('today() returns consistent results within the same day', () {
      final morning = DateTime(2024, 7, 31, 1, 0, 0);
      final evening = DateTime(2024, 7, 31, 23, 59, 59);

      withClock(Clock.fixed(morning), () {
        final morningResult = today();
        withClock(Clock.fixed(evening), () {
          final eveningResult = today();
          expect(morningResult, equals(eveningResult));
        });
      });
    });

    test('dateOneWeekAgo() returns the date 7 days before today', () {
      final now = DateTime(2024, 7, 31, 15, 30, 45); // Arbitrary date and time
      withClock(Clock.fixed(now), () {
        final result = dateOneWeekAgo();
        final expected = DateTime(2024, 7, 24); // 7 days before 2024-07-31
        expect(result, equals(expected));
      });
    });

    test('dateOneWeekAgo() handles month rollover correctly', () {
      final now = DateTime(2024, 8, 3, 12, 0, 0); // A date early in the month
      withClock(Clock.fixed(now), () {
        final result = dateOneWeekAgo();
        final expected =
            DateTime(2024, 7, 27); // Should roll back to previous month
        expect(result, equals(expected));
      });
    });

    test('dateOneWeekAgo() handles year rollover correctly', () {
      final now = DateTime(2025, 1, 4, 12, 0, 0); // A date early in the year
      withClock(Clock.fixed(now), () {
        final result = dateOneWeekAgo();
        final expected =
            DateTime(2024, 12, 28); // Should roll back to previous year
        expect(result, equals(expected));
      });
    });
  });
}
