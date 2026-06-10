import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/order_base.dart';
import 'package:mn1/home/screens/complete_order/show_complete_order_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/custom_btn_date_between.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowCompleteOrder extends StatefulWidget {
  const ShowCompleteOrder({super.key});

  @override
  State<ShowCompleteOrder> createState() => _ShowCompleteOrderState();
}

class _ShowCompleteOrderState extends State<ShowCompleteOrder> {
  String startDate = DateTime.now()
      .subtract(Duration(days: 4))
      .toString()
      .split(' ')[0];
  String endDate = DateTime.now()
      .add(Duration(days: 2))
      .toString()
      .split(' ')[0];
  late ApplicationController<Order> controller;

  @override
  void initState() {
    controller = .new();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        TEXT(text: getText('complete_order'), size: 25, bold: true),
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .center,
          children: [
            SizedBox(
              width: pageSizeWidth(context, 0.6),
              child: Row(
                crossAxisAlignment: .center,
                spacing: 12,
                mainAxisAlignment: .start,
                children: [
                  Expanded(
                    child: CustomField(
                      icon: Icons.search,
                      hintText: "${getText('client_name')} ....",
                      onChanged: (p0) {
                        controller.search(p0, (p0) => p0.userName.toString());
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomField(
                      icon: Icons.search,
                      hintText: "${getText('order_number')} ....",
                      onChanged: (p0) {
                        controller.search(p0, (p0) => p0.id.toString());
                      },
                    ),
                  ),
                ],
              ),
            ),
            CustomBtnDateBetween(
              onselect: (p0, p1) {
                setState(() {
                  startDate = p0;
                  endDate = p1;
                });
              },
            ),
          ],
        ),
        CustomHeadTable(
          headData: [
            CustomHeadTableItems(flex: 1, text: getText('num')),
            CustomHeadTableItems(flex: 2, text: getText('order_number')),
            CustomHeadTableItems(flex: 4, text: getText('client_name')),
            CustomHeadTableItems(flex: 2, text: getText('state')),
            CustomHeadTableItems(flex: 2, text: getText('price')),
            CustomHeadTableItems(flex: 2, text: getText('date')),
            CustomHeadTableItems(flex: 2, text: getText('count_goods')),
            CustomHeadTableItems(flex: 1, text: getText('more')),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: OrderBase.getOrder(
              userId: 0,
              startDate: startDate,
              endDate: endDate,
              status: OrderStatus.complete,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.data!.success) {
                return Center(
                  child: TEXT(
                    text: snapshot.data!.msg,
                    size: 20,
                    bold: true,
                    center: true,
                  ),
                );
              } else {
                controller.equal(snapshot.data!.data);
                return ShowCompleteOrderView(controller: controller);
              }
            },
          ),
        ),
      ],
    );
  }
}
