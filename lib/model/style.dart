import 'package:flutter/material.dart';

// 변수 앞에 '_'를 붙이면 import 하더라도 다른파일에서 사용 못함!!!

var theme = ThemeData(
  fontFamily: 'Raleway',
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: const Color(0xff5a95ff),
  scaffoldBackgroundColor: Colors.white,

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xfff1f6f9),
    elevation: 10,
    enableFeedback: false,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
      )
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
        color: Colors.black
        , fontSize: 30
        , fontFamily: 'Raleway'
        , fontWeight: FontWeight.w900
    ),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff5a95ff),
    shape: CircleBorder(),
    iconSize: 30,
    foregroundColor: Colors.white
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.red,
  )
);