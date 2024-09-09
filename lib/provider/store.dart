import 'dart:collection';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';
import '../util/fn_calendar.dart';
import '../util/fn_firebase.dart';

class Store with ChangeNotifier {

  var bottomNavCurrTab = 0; // 하단 바
  var topCurrTab = 0; // 상단 메뉴바

  DateTime pvSelectedDay = DateTime.now();

  LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap<DateTime, List<Event>>();

  chgBottomTabNum(int num) {
    bottomNavCurrTab = num;
    notifyListeners();
  }

  chgTopTabNum(int num) {
    topCurrTab = num;
    notifyListeners();
  }

  chgPvSelectedDay(DateTime selectedDay){
    pvSelectedDay = selectedDay;
    notifyListeners();
  }

  chgKEvents(DateTime currDay) async{

    var result = selectCalendarData(currDay);

    result.then((val) {
      kEvents = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(val);

      notifyListeners();
    });
  }
}