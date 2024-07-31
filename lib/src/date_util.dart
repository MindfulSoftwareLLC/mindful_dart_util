import 'package:clock/clock.dart';

/// Today's date
DateTime today() {
  final now = clock.now();
  return DateTime(now.year, now.month, now.day);
}

/// The date 7 days ago
DateTime dateOneWeekAgo() {
  final sevenDaysAgo = clock.now().subtract(const Duration(days: 7));
  return DateTime(sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day);
}
