// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';

class ReportBase {
  static Future<ApiData<Map<String, dynamic>>> report({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: {});
      }
      var response = await http.post(
        Uri.parse("$domin/reports/get_reports"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({'start_date': startDate, 'end_date': endDate}),
      );
      final data = jsonDecode(response.body);
      print(data);
      return ApiData(
        success: data["success"],
        msg: data["message"],
        data: data["data"],
      );
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: {});
    }
  }
}
