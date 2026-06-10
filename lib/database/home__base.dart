// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/open_data.dart';

class HomeBase {
  static Future<ApiData<OpenData?>> get({required int id}) async {
    try {
      var response = await http.get(
        Uri.parse("$domin/home/web"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          "id": id.toString(),
        },
      );
      final data = jsonDecode(response.body);
      if (data["success"]) {
        await LocalBase.saveOpenData(data: data["data"]);
      }
      return ApiData<OpenData?>(
        success: data["success"],
        msg: data["message"],
        data: data["success"] == true ? OpenData.fromMap(data["data"]) : null,
      );
    } catch (e) {
      return ApiData<OpenData?>(success: false, msg: "$e", data: null);
    }
  }
}
