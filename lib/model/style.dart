import 'package:flutter/material.dart';

// 변수 앞에 '_'를 붙이면 import 하더라도 다른파일에서 사용 못함!!!

var theme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 2,
      selectedItemColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey,
        )
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 1, // 그림자 크기
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
      actionsIconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.black)
    )
);