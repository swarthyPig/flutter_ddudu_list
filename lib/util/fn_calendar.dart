import 'dart:ui';

final kToday = DateTime.now();
final kFirstDay = DateTime.now().subtract(const Duration(days: 365 * 10));
final kLastDay = DateTime.now().add(const Duration(days: 365 * 10));

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    buffer.write(hexString.replaceFirst('0x', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}