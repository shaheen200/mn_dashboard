// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/models/image_good.dart';
import 'package:mn1/tools/custom_image/select_list_image.dart';

class StoreBase {
  static Future<ApiData<List<Good>>> get({required bool all}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.get(
        Uri.parse("$domin/store/get_goods"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
          'all': all.toString(),
        },
      );
      final data = jsonDecode(response.body);

      return ApiData<List<Good>>(
        success: data["success"],
        msg: data["message"],
        data: data["success"] ? Good.fromList(data['data']) : [],
      );
    } catch (e) {
      return ApiData<List<Good>>(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData<Good?>> add({
    required String name,
    required String code,
    required String price,
    required String exist,
    required String departmentId,
    required List<SelectListImageData> listImage,
  }) async {
    final user = await LocalBase.getOpenData();
    if (user == null) {
      return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
    }
    var uri = Uri.parse("$domin/store/add_good");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'id': user.id.toString(), 'v-app': vApp});

    request.fields['name'] = name;
    request.fields['code'] = code;
    request.fields['price'] = price;
    request.fields['exist'] = exist;
    request.fields['department_id'] = departmentId;

    for (var i = 0; i < listImage.length; i++) {
      var img1File = await http.MultipartFile.fromBytes(
        '$i',
        listImage[i].bytes,
        filename: 'image.png',
      );
      request.files.add(img1File);
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return ApiData<Good?>(
        success: jsonResponse["success"],
        msg: jsonResponse["message"],
        data: jsonResponse["success"]
            ? Good.fromMap(jsonResponse["data"])
            : null,
      );
    } catch (e) {
      return ApiData<Good?>(success: false, msg: "$e", data: null);
    }
  }

  static Future<ApiData<Good?>> update({
    required int id,
    String name = '',
    String code = '',
    String price = '',
    String exist = '',
    String departmentId = '',
    String isActive = '',
  }) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
      }
      var response = await http.post(
        Uri.parse("$domin/store/edit_good"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({
          'id': id,
          'name': name,
          'code': code,
          'price': price,
          'exist': exist,
          'department_id': departmentId,
          'is_active': isActive,
        }),
      );
      final data = jsonDecode(response.body);

      return ApiData<Good?>(
        success: data["success"],
        msg: data["message"],
        data: data["success"] ? Good.fromMap(data['data']) : null,
      );
    } catch (e) {
      return ApiData<Good?>(success: false, msg: "$e", data: null);
    }
  }

  static Future<ApiData<List<GoodImage>>> getImage({required int id}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/store/get_image"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({'id': id}),
      );
      final data = jsonDecode(response.body);
      return ApiData<List<GoodImage>>(
        success: data["success"],
        msg: data["message"],
        data: data["success"] ? GoodImage.fromList(data['data']) : [],
      );
    } catch (e) {
      return ApiData<List<GoodImage>>(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData> deleteImage({required int id}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/store/delete_image"),
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

  ///  image
  static Future<ApiData> addImage({
    required String id,
    required List<SelectListImageData> listImage,
  }) async {
    final user = await LocalBase.getOpenData();
    if (user == null) {
      return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
    }
    var uri = Uri.parse("$domin/store/add_image");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'id': user.id.toString(), 'v-app': vApp});

    request.fields['id'] = id;
    for (var i = 0; i < listImage.length; i++) {
      var img1File = await http.MultipartFile.fromBytes(
        '$i',
        listImage[i].bytes,
        filename: 'image.png',
      );
      request.files.add(img1File);
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return ApiData(
        success: jsonResponse["success"],
        msg: jsonResponse["message"],
        data: null,
      );
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: null);
    }
  }
}
