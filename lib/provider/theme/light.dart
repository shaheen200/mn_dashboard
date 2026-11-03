import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  cardColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: const Color(
    0xff1E293B,
  ), // رمادي داكن هادئ ومريح للعين بدل الأسود الصريح
  shadowColor: Colors.black12,
  primaryColor: const Color(0xff2563EB), // أزرق احترافي هادئ (Modern Blue)
  useMaterial3: true,
  splashColor: Colors.blue.shade100,
  scaffoldBackgroundColor: const Color(0xffF8FAFC), // خلفية ناعمة ومريحة
  fontFamily: "tajawal",
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffF8FAFC),
    foregroundColor: Color(0xff1E293B),
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xff1E293B),
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "tajawal",
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    elevation: 15,
    shadowColor: Colors.black26,
  ),
);
