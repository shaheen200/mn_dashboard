import 'package:flutter/material.dart';

class ChangeProvider extends ChangeNotifier {
  bool darkMode = false;
  bool language = false;

  Future<void> changeTheme(bool value) async {
    darkMode = value;
    notifyListeners();
  }

  Future<void> changeLanguage(bool value) async {
    language = value;
    notifyListeners();
  }

  void setValue(bool isDark, bool isEn) {
    darkMode = isDark;
    language = isEn;
  }
}
