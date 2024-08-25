import 'dart:collection';
import 'dart:ui';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String topic;
  String description;
  String year;
  String month;
  String day;
  String color;
  String complete;

  Event(
      this.topic
      , this.description
      , this.year
      , this.month
      , this.day
      , this.color
      , this.complete);
}

final kToday = DateTime.now();
final kFirstDay = DateTime.now().subtract(const Duration(days: 365 * 10));
final kLastDay = DateTime.now().add(const Duration(days: 365 * 10));

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(eventSource);

Map<DateTime,List<Event>> eventSource = {
  DateTime(2024,8,3) : [Event('테스트1', "설명1", "2024", "8", "3", "0xffFF0000", "1"),Event('테스트2', "설명2", "2024", "8", "3", "0xffFF0000", "0")],
  DateTime(2024,8,5) : [Event('테스트1', "설명1", "2024", "8", "5", "0xffFFD700", "1")],
  DateTime(2024,8,8) : [Event('테스트1', "설명1", "2024", "8", "8", "0xffFFB6C1", "1")],
  DateTime(2024,8,11) : [Event('테스트1', "설명1", "2024", "8", "11", "0xffFF0000", "1"),Event('테스트2', "설명2", "2024", "8", "11", "0xffFFD700", "0"),Event('테스트3', "설명3", "2024", "8", "11", "0xffFFB6C1", "1"),Event('테스트4', "설명4", "2024", "8", "11", "0xff00FF7F", "0"),Event('테스트5', "설명5", "2024", "8", "11", "0xffFFD700", "1")],
  DateTime(2024,8,13) : [Event('테스트1', "설명1", "2024", "8", "13", "0xff00FF7F", "1")],
  DateTime(2024,8,15) : [Event('테스트1', "설명1", "2024", "8", "15", "0xffFF0000", "1")],
  DateTime(2024,8,18) : [Event('테스트1', "설명1", "2024", "8", "18", "0xff00FF7F", "1")],
  DateTime(2024,8,20) : [Event('테스트1', "설명1", "2024", "8", "20", "0xffFF0000", "1"),Event('테스트2', "설명2", "2024", "8", "20", "0xffFFB6C1", "0"),Event('테스트3', "설명3", "2024", "8", "20", "0xffA9A9A9", "1")],
  DateTime(2024,8,21) : [Event('테스트1', "설명1", "2024", "8", "21", "0xffFFB6C1", "1"),Event('테스트2', "설명2", "2024", "8", "21", "0xffFFD700", "0")]
};

/*final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime(2024, 8, 21),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}', false)));*/

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