import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/home/screens/not_complete_order/accept_order/accept_order.dart';
import 'package:mn1/home/screens/not_complete_order/dialog/show_order_more_dialog.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/funTool.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';

class ShowNotCompleteOrderView extends StatefulWidget {
  final ApplicationController<Order> controller;
  const ShowNotCompleteOrderView({super.key, required this.controller});

  @override
  State<ShowNotCompleteOrderView> createState() =>
      _ShowNotCompleteOrderViewState();
}

class _ShowNotCompleteOrderViewState extends State<ShowNotCompleteOrderView> {
  late VoidCallback _goodsListener;

  @override
  void initState() {
    super.initState();

    _goodsListener = () {
      if (mounted) {
        setState(() {});
      }
    };

    widget.controller.addListener(_goodsListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_goodsListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.controller.items.length,
      itemBuilder: (context, index) {
        return CustomBodyTable(
          bodyData: [
            CustomBodyTableItems(
              flex: 1,
              widget: TEXT(text: "${index + 1}", bold: true, size: 17),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].id}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 4,
              widget: TEXT(
                text: "${widget.controller.items[index].userName}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                color: Colors.amber,
                text: "${widget.controller.items[index].statusText}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].totalPrice}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].time}",
                bold: true,
                size: 17,
              ),
            ),

            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].countGoods}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 1,
              widget: CustomPop(
                items: [
                  CustomPopItems(
                    text: getText('show_order'),
                    onTap: () {
                      goPage(
                        context,
                        AcceptOrder(
                          orderController: widget.controller,
                          indexOrder: index,
                        ),
                      );
                    },
                  ),
                  CustomPopItems(
                    text: getText('order_data'),
                    onTap: () {
                      showOrderMoreDialog(
                        context,
                        order: widget.controller.items[index],
                      );
                    },
                  ),
                  CustomPopItems(
                    text: getText('by'),
                    onTap: () {
                      byIdDialog(
                        context: context,
                        id: widget.controller.items[index].userId,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
