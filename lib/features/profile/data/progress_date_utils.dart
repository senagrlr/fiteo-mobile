String progressDateKey(DateTime date) {
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

String progressMonthKey(DateTime date) {
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}';
}

DateTime progressDateOnly(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
  );
}