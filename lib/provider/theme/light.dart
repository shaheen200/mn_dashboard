import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  cardColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.black,
  shadowColor: Colors.black45,
  primaryColor: const Color(0xff1484EC),
  useMaterial3: true,
  splashColor: Colors.blue.shade200,
  scaffoldBackgroundColor: const Color(0xffF9F9FA),
  fontFamily: "tajawal",
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffF9F9FA),
    foregroundColor: Colors.black,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: "tajawal",
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    elevation: 20,
    shadowColor: Colors.black,
  ),
);
