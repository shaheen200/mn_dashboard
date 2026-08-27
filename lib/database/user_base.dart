// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/user.dart';

class UsersBase {
  static Future<ApiData<int>> login({
    required String phone,
    required String pw,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("$domin/user/login"),
        headers: headApi,
        body: jsonEncode({
          "phone": phone,
          "pw": pw,
          'firebase_token': '',
          'from': 'web',
        }),
      );
      final data = jsonDecode(response.body);
      print(data);

      return ApiData(
        success: data["success"],
        msg: data["message"],
        data: data['data'] != null ? data['data']['id'] ?? 0 : 0,
      );
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: 0);
    }
  }

  static Future<ApiData<User?>> add({
    required String phone,
    required String name,
    required String pw,
    required String role,
    required String salary,
    required String profileImage,
    required String address,
  }) async {
    final user = await LocalBase.getOpenData();
    if (user == null) {
      return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
    }
    var uri = Uri.parse("$domin/user/ceate_account");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'id': user.id.toString(), 'v-app': vApp});

    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['pw'] = pw;
    request.fields['role'] = role;
    request.fields['salary'] = salary;
    request.fields['address'] = address;

    if (profileImage.isNotEmpty) {
      var img1File = await http.MultipartFile.fromPath(
        'profile_image',
        profileImage,
      );
      request.files.add(img1File);
    }
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      print(jsonResponse);
      return ApiData<User?>(
        success: jsonResponse["success"],
        msg: jsonResponse["message"],
        data: jsonResponse["success"]
            ? User.fromMap(jsonResponse["data"])
            : null,
      );
    } catch (e) {
      return ApiData<User?>(success: false, msg: "$e", data: null);
    }
  }

  static Future<ApiData<User?>> update({
    String? id,
    String phone = '',
    String name = '',
    String salary = '',
    String profileImage = '',
    String isActive = '',
    String muteNofi = '',
    String address = '',
  }) async {
    var uri = Uri.parse("$domin/user/update_account");
    var request = http.MultipartRequest('POST', uri);
    final user = await LocalBase.getOpenData();
    if (user == null) {
      return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
    }
    request.headers.addAll({'id': user.id.toString(), 'v-app': vApp});
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['id'] = id ?? user.id.toString();
    request.fields['salary'] = salary;
    request.fields['is_active'] = isActive;
    request.fields['mute_nofi'] = muteNofi;
    request.fields['addres'] = address;
    if (profileImage.isNotEmpty) {
      var img1File = await http.MultipartFile.fromPath(
        'profile_image',
        profileImage,
      );
      request.files.add(img1File);
    }
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return ApiData<User?>(
        success: jsonResponse["success"],
        msg: jsonResponse["message"],
        data: jsonResponse["data"] == null
            ? null
            : User.fromMap(jsonResponse["data"]),
      );
    } catch (e) {
      return ApiData<User?>(success: false, msg: "$e", data: null);
    }
  }

  static Future<ApiData<User?>> getById({int? id}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
      }
      print(id);
      var response = await http.post(
        Uri.parse("$domin/user/get_by_id"),
        headers: headApi,
        body: jsonEncode({"id": id ?? user.id}),
      );
      final data = jsonDecode(response.body);
      print(data);
      return ApiData<User?>(
        success: data["success"],
        msg: data["message"],
        data: data["data"] == null ? null : User.fromMap(data["data"][0]),
      );
    } catch (e) {
      return ApiData<User?>(success: false, msg: "$e", data: null);
    }
  }

  static Future<ApiData<List<User>>> getUsers({required String type}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/user/get_user"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({'type': type}),
      );
      final data = jsonDecode(response.body);
      return ApiData<List<User>>(
        success: data["success"],
        msg: data["message"],
        data: data["data"] == null ? [] : User.fromList(data["data"]),
      );
    } catch (e) {
      return ApiData<List<User>>(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData> logout() async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/user/logout"),
        headers: headApi,
        body: jsonEncode({"id": user.id}),
      );
      final data = jsonDecode(response.body);
      return ApiData(success: data["success"], msg: data["message"], data: []);
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData> changePw({
    required String oldPw,
    required String newPw,
    required String newPw2,
  }) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/user/change_pw"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          "id": user.id.toString(),
        },
        body: jsonEncode({
          "id": user.id,
          'old_pw': oldPw,
          'new_pw1': newPw,
          'new_pw2': newPw2,
        }),
      );
      final data = jsonDecode(response.body);
      return ApiData(
        success: data["success"],
        msg: data["message"],
        data: null,
      );
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: null);
    }
  }
}
