// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn1/constant/const.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/models/order_good.dart';

class OrderBase {
  static Future<ApiData> addOrder({required List<dynamic> listGood}) async {
    try {
      final user = await LocalBase.getOpenData();

      var response = await http.post(
        Uri.parse("$domin/order/add_order"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          "id": user!.id.toString(),
        },
        body: jsonEncode({'list_good': listGood}),
      );
      final data = jsonDecode(response.body);
      return ApiData(success: data["success"], msg: data["message"], data: []);
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData<List<Order>>> getOrder({
    int? userId,
    required String startDate,
    required String endDate,
    required OrderStatus status,
  }) async {
    try {
      final user = await LocalBase.getOpenData();

      var response = await http.post(
        Uri.parse("$domin/order/get_order"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          "id": user!.id.toString(),
        },
        body: jsonEncode({
          'status': status.name,
          'start_date': startDate,
          'end_date': endDate,
          'user_id': userId ?? user,
        }),
      );
      final data = jsonDecode(response.body);
      print(data);
      return ApiData<List<Order>>(
        success: data["success"],
        msg: data["message"],
        data: Order.fromList(data["data"]),
      );
    } catch (e) {
      return ApiData<List<Order>>(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData<List<OrderGood>>> getOrderGoods({
    required int orderId,
  }) async {
    try {
      final user = await LocalBase.getOpenData();

      var response = await http.post(
        Uri.parse("$domin/order/get_order_goods"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          "id": user!.id.toString(),
        },
        body: jsonEncode({'order_id': orderId}),
      );
      final data = jsonDecode(response.body);
      print(data);
      return ApiData<List<OrderGood>>(
        success: data["success"],
        msg: data["message"],
        data: OrderGood.fromList(data['data']),
      );
    } catch (e) {
      return ApiData<List<OrderGood>>(success: false, msg: "$e", data: []);
    }
  }

  static Future<ApiData> acceptOrder({
    required int orderId,
    required String status,
    required String note,
    required List<dynamic> listData,
  }) async {
    try {
      final user = await LocalBase.getOpenData();

      var response = await http.post(
        Uri.parse("$domin/order/accept_order"),
        headers: {
          'Content-Type': 'application/json',
          'v-app': vApp,
          "id": user!.id.toString(),
        },
        body: jsonEncode({
          'id': orderId,
          'status': status,
          'note': note,
          'list_data': listData,
        }),
      );
      final data = jsonDecode(response.body);
      print(data);
      return ApiData(success: data["success"], msg: data["message"], data: []);
    } catch (e) {
      return ApiData(success: false, msg: "$e", data: []);
    }
  }
}

enum OrderStatus { complete, un_complete }
