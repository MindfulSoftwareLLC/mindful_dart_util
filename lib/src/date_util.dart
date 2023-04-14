/// Today's date
/// Today's date
DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// The date 7 days ago
DateTime dateOneWeekAgo() {
  return today().subtract(const Duration(days: 7));
}
