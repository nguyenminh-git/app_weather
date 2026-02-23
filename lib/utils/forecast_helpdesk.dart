import '../models/forecast.dart';

List<ForeCastItem> pick5Days(List<ForeCastItem> items) {
  final Map<String, List<ForeCastItem>> grouped = {};

  for (final item in items) {
    final key = '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
    grouped.putIfAbsent(key, () => []).add(item);
  }

  final days = grouped.values.toList()
    ..sort((a, b) => a.first.dateTime.compareTo(b.first.dateTime));

  final List<ForeCastItem> result = [];

  for (final day in days) {
    day.sort((a, b) {
      final da = (a.dateTime.hour - 12).abs();
      final db = (b.dateTime.hour - 12).abs();
      return da.compareTo(db);
    });
    result.add(day.first);
    if (result.length == 5) break;
  }

  return result;
}