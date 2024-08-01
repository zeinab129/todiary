import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
      textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Colors.black, fontSize: 45, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(
        color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w300),
    displayMedium: TextStyle(color: Colors.white, fontSize: 21),
    displaySmall: TextStyle(
        color: Color.fromARGB(255, 234, 234, 234),
        fontSize: 14,
        fontWeight: FontWeight.w400),
    //headline4
    labelLarge: TextStyle(
      color: Colors.grey,
      fontSize: 17,
    ),
    //headline5
    labelMedium: TextStyle(
      color: Colors.grey,
      fontSize: 16,
    ),
    //subtitle2
    titleSmall: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    //headline6
    labelSmall: TextStyle(
      fontSize: 40,
      color: Colors.black,
      fontWeight: FontWeight.w300,
    ),
  ));
}
