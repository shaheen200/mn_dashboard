// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/offer.dart';

class OfferBase {
  static Future<ApiData> addOffer({
    required int goodId,
    required String price,
    required String title,
    required String descrption,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: []);
      }
      var response = await http.post(
        Uri.parse("$domin/offer/add_offer"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({
          'good_id': goodId,
          'price': price,
          'title': title,
          'descrption': descrption,
          'from_date': fromDate,
          'to_date': toDate,
        }),
      );
      final data = jsonDecode(response.body);

      return ApiData(success: data["success"], msg: data["message"], data: []);
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData> delete({required int id}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData(success: false, msg: 'يرجي تسجيل الدخول', data: null);
      }
      var response = await http.post(
        Uri.parse("$domin/offer/delete_offer"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({'id': id}),
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

  static Future<ApiData<List<Offer>>> getOffers({required int id}) async {
    try {
      final user = await LocalBase.getOpenData();
      if (user == null) {
        return ApiData<List<Offer>>(
          success: false,
          msg: 'يرجي تسجيل الدخول',
          data: [],
        );
      }
      var response = await http.post(
        Uri.parse("$domin/offer/get_offers"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          'id': user.id.toString(),
        },
        body: jsonEncode({'good_id': id}),
      );
      final data = jsonDecode(response.body);
      return ApiData<List<Offer>>(
        success: data["success"],
        msg: data["message"],
        data: data["success"] ? Offer.fromList(data['data']) : [],
      );
    } catch (e) {
      return ApiData<List<Offer>>(success: false, msg: "$e", data: []);
    }
  }
}
