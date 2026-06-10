import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/order_base.dart';
import 'package:mn1/home/screens/not_complete_order/accept_order/accept_order_dialog.dart';
import 'package:mn1/home/screens/not_complete_order/accept_order/accept_order_view.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/models/order_good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';

class AcceptOrder extends StatefulWidget {
  final ApplicationController<Order> orderController;
  final int indexOrder;
  final bool edit;
  const AcceptOrder({
    super.key,
    required this.orderController,
    required this.indexOrder,
    this.edit = true,
  });

  @override
  State<AcceptOrder> createState() => _AcceptOrderState();
}

class _AcceptOrderState extends State<AcceptOrder> {
  late ApplicationController<OrderGood> controller;
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
    return Scaffold(
      appBar: AppBar(title: Text(getText('show_order'))),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: OrderBase.getOrderGoods(
            orderId: widget.orderController.items[widget.indexOrder].id,
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
              return Column(
                crossAxisAlignment: .end,
                children: [
                  Visibility(
                    visible: widget.edit,
                    child: Row(
                      spacing: 15,
                      children: [
                        CustomBtn(
                          btnColor: Colors.red,
                          onClick: () {
                            acceptOrderDialog(
                              orderController: widget.orderController,
                              indexOrder: widget.indexOrder,
                              context,

                              status: 'delete',
                              controller: controller,
                            );
                          },
                          text: getText('delete'),
                          w: 0.12,
                        ),
                        const SizedBox(width: 10),
                        CustomBtn(
                          btnColor: Colors.green,
                          onClick: () {
                            acceptOrderDialog(
                              orderController: widget.orderController,
                              indexOrder: widget.indexOrder,
                              context,

                              status: 'accept',
                              controller: controller,
                            );
                          },
                          text: getText('accept'),
                          w: 0.12,
                        ),
                      ],
                    ),
                  ),
                  CustomHeadTable(
                    headData: [
                      CustomHeadTableItems(flex: 1, text: getText('num')),
                      CustomHeadTableItems(flex: 3, text: getText('good_name')),
                      CustomHeadTableItems(flex: 2, text: getText('depart')),
                      CustomHeadTableItems(flex: 2, text: getText('count')),
                      CustomHeadTableItems(flex: 2, text: getText('price')),
                      CustomHeadTableItems(flex: 2, text: getText('total')),
                    ],
                  ),
                  Expanded(
                    child: AcceptOrderView(
                      controller: controller,
                      edit: widget.edit,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
