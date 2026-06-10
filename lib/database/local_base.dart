import 'dart:convert';

import 'package:mn1/models/open_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RoleType { client, admin, emp }

class LocalBase {
  static const _localDataKey = 'local_data';

  /// Save OpenData data
  static Future<void> saveOpenData({required Map<String, dynamic> data}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localDataKey, jsonEncode(data));
  }

  /// Get OpenData data as model
  static Future<OpenData?> getOpenData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return OpenData.fromMap(
        jsonDecode(prefs.getString(_localDataKey) ?? '{}'),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearOpenData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localDataKey);
  }
}
