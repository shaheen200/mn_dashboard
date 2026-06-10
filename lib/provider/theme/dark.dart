import 'package:flutter/material.dart';

final ThemeData dartTheme = ThemeData(
  primaryColorLight: Colors.black,
  primaryColorDark: Colors.white,
  primaryColor: const Color.fromARGB(255, 117, 39, 35),
  useMaterial3: true,
  splashColor: Colors.blue.shade200,
  scaffoldBackgroundColor: const Color(0xff3B4652),
  fontFamily: "tajawal",
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff3B4652),
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: "tajawal")),
  drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black, elevation: 20, shadowColor: Colors.white),
);
