import 'dart:collection';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';
import '../util/fn_calendar.dart';

class Store with ChangeNotifier {

  var bottomNavCurrTab = 0; // 하단 바
  var topCurrTab = 0; // 상단 메뉴바

  DateTime? _pvSelectedDay = DateTime.now();
  DateTime? get pvSelectedDay => _pvSelectedDay;

  LinkedHashMap<DateTime, List<Event>> _kEvents = LinkedHashMap<DateTime, List<Event>>();
  LinkedHashMap<DateTime, List<Event>> get kEvents => _kEvents;

  chgBottomTabNum(int num) {
    bottomNavCurrTab = num;
    notifyListeners();
  }

  chgTopTabNum(int num) {
    topCurrTab = num;
    notifyListeners();
  }

  set pvSelectedDay(DateTime? selectedDay){
    _pvSelectedDay = selectedDay;
    notifyListeners();
  }

  set kEvents(LinkedHashMap<DateTime, List<Event>> data) {
    _kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(data);

    notifyListeners();
  }
}