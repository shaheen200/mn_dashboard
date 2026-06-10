// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/department.dart';

class DepartmentBase {
  static Future<ApiData<List<Department>>> get({required bool all}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.get(
        Uri.parse("$domin/department/get_depart"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
          'all': all.toString(),
        },
      );
      final data = jsonDecode(response.body);

      return ApiData<List<Department>>(
        success: data["success"],
        msg: data["message"],
        data: data["success"] ? Department.fromList(data['data']) : [],
      );
    } catch (e) {
      return ApiData<List<Department>>(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData<Department?>> add({
    required String name,
    required List<int>? image,
  }) async {
    final user = await LocalBase.getOpenData();
    if (user == null) {
      return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
    }
    var uri = Uri.parse("$domin/department/add_depart");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'id': user.id.toString(), 'v-app': vApp});

    request.fields['name'] = name;

    if (image != null) {
      var img1File = await http.MultipartFile.fromBytes(
        'image',
        image,
        filename: 'image.png',
      );
      request.files.add(img1File);
    }
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return ApiData<Department?>(
        success: jsonResponse["success"],
        msg: jsonResponse["message"],
        data: jsonResponse["success"]
            ? Department.fromMap(jsonResponse["data"])
            : null,
      );
    } catch (e) {
      return ApiData<Department?>(success: false, msg: "$e", data: null);
    }
  }

  static Future<ApiData<Department?>> update({
    required String id,
    String name = '',
    List<int>? image,
    String isActive = '',
  }) async {
    var uri = Uri.parse("$domin/department/edit_depart");
    var request = http.MultipartRequest('POST', uri);
    final user = await LocalBase.getOpenData();
    if (user == null) {
      return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
    }
    request.headers.addAll({'id': user.id.toString(), 'v-app': vApp});
    request.fields['name'] = name;
    request.fields['id'] = id;
    request.fields['is_active'] = isActive;
    if (image != null) {
      var img1File = await http.MultipartFile.fromBytes(
        'image',
        image,
        filename: 'image.png',
      );
      request.files.add(img1File);
    }
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      print(jsonResponse);
      return ApiData<Department?>(
        success: jsonResponse["success"],
        msg: jsonResponse["message"],
        data: jsonResponse["data"] == null
            ? null
            : Department.fromMap(jsonResponse["data"]),
      );
    } catch (e) {
      return ApiData<Department?>(success: false, msg: "$e", data: null);
    }
  }
}
