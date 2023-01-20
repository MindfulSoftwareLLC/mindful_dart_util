/// Today's date
DateTime todayDU() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// The date 7 days ago
DateTime dateOneWeekAgoDU() {
  return todayDU().subtract(const Duration(days: 7));
}
