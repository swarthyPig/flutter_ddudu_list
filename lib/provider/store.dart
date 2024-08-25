import 'package:flutter/cupertino.dart';

class Store with ChangeNotifier {

  var bottomNavCurrTab = 0; // 하단 바
  var topCurrTab = 0; // 상단 메뉴바

  DateTime? pvSelectedDay = DateTime.now();

  chgBottomTabNum(int num) {
    bottomNavCurrTab = num;
    notifyListeners();
  }

  chgTopTabNum(int num) {
    topCurrTab = num;
    notifyListeners();
  }

  setSelectDay(DateTime? selectedDay){
    pvSelectedDay = selectedDay;
    notifyListeners();
  }
}