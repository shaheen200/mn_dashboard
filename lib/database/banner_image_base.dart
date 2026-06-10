// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/image_banner.dart';

class BannerImageBase {
  static Future<ApiData<List<ImageBanner>>> get({required bool all}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/banner_image/get_banner_image"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({"all": all}),
      );
      final data = jsonDecode(response.body);
      print(data);

      return ApiData<List<ImageBanner>>(
        success: data["success"],
        msg: data["message"],
        data: ImageBanner.fromList(data['data']),
      );
    } catch (e) {
      return ApiData<List<ImageBanner>>(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData<ImageBanner?>> add({
    required PlatformFile? image,
  }) async {
    final user = await LocalBase.getOpenData();
    if (user == null) {
      return ApiData<ImageBanner?>(
        success: false,
        msg: 'يرجي تسجيل الدخول',
        data: null,
      );
    }
    var uri = Uri.parse("$domin/banner_image/add_banner_image");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'id': user.id.toString(), 'v-app': vApp});

    // request.fields['name'] = name;

    if (image != null) {
      var img1File = await http.MultipartFile.fromBytes(
        'image',
        image.bytes!,
        filename: image.name,
      );
      request.files.add(img1File);
    }
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return ApiData<ImageBanner?>(
        success: jsonResponse["success"],
        msg: jsonResponse["message"],
        data: jsonResponse["success"]
            ? ImageBanner.fromJson(jsonResponse["data"])
            : null,
      );
    } catch (e) {
      return ApiData<ImageBanner?>(success: false, msg: "$e", data: null);
    }
  }

  static Future<ApiData> delete({required int id}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/banner_image/delete_banner_image"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({'id': id}),
      );
      final data = jsonDecode(response.body);
      return ApiData(success: data["success"], msg: data["message"], data: []);
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData<ImageBanner?>> edit({
    required int id,
    required bool isActive,
  }) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData<ImageBanner?>(
          success: false,
          msg: 'يرجي تسجيل الدخول',
          data: null,
        );
      }
      var response = await http.post(
        Uri.parse("$domin/banner_image/edit_banner_image"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({"id": id, 'is_active': isActive}),
      );
      final data = jsonDecode(response.body);
      return ApiData<ImageBanner?>(
        success: data["success"],
        msg: data["message"],
        data: data["success"] ? ImageBanner.fromJson(data["data"]) : null,
      );
    } catch (e) {
      return ApiData<ImageBanner?>(success: false, msg: "$e", data: null);
    }
  }
}
