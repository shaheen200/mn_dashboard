import 'package:flutter/material.dart';

final ThemeData dartTheme = ThemeData(
  primaryColorLight: Colors.white,
  primaryColorDark: const Color(0xffF1F5F9),
  primaryColor: const Color(0xff3B82F6), // أزرق متناسق وواضح في الوضع الداكن
  useMaterial3: true,
  splashColor: Colors.blue.shade900,
  scaffoldBackgroundColor: const Color(
    0xff0F172A,
  ), // خلفية داكنة فاخرة (Slate Dark)
  cardColor: const Color(0xff1E293B), // لون البطاقات متناسق مع الخلفية الداكنة
  fontFamily: "tajawal",
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff0F172A),
    foregroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "tajawal",
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xff1E293B),
    elevation: 20,
    shadowColor: Colors.black54,
  ),
);
