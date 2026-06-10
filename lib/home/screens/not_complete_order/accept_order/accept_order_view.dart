import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/models/order_good.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class AcceptOrderView extends StatefulWidget {
  final ApplicationController<OrderGood> controller;
  final bool edit;
  const AcceptOrderView({
    super.key,
    required this.controller,
    required this.edit,
  });

  @override
  State<AcceptOrderView> createState() => _AcceptOrderViewState();
}

class _AcceptOrderViewState extends State<AcceptOrderView> {
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
              flex: 3,
              widget: TEXT(
                text: "${widget.controller.items[index].goodName}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].departName}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: Visibility(
                visible: widget.edit,
                replacement: TEXT(
                  text: "${widget.controller.items[index].count}",
                  bold: true,
                  size: 17,
                ),
                child: CustomField(
                  type: CustomFieldType.number,
                  icon: Icons.numbers,
                  controller: TextEditingController(
                    text: widget.controller.items[index].count.toString(),
                  ),
                  onFieldSubmitted: (p0) {
                    widget.controller.editItem(
                      OrderGood(
                        id: widget.controller.items[index].id,
                        orderId: widget.controller.items[index].orderId,
                        goodId: widget.controller.items[index].goodId,
                        price: widget.controller.items[index].price,
                        count: num.parse(p0),
                        time: widget.controller.items[index].time,
                        totalPrice: widget.controller.items[index].totalPrice,
                        goodName: widget.controller.items[index].goodName,
                        departName: widget.controller.items[index].departName,
                      ),
                      (p0, p1) {
                        return p0.id == p1.id;
                      },
                    );
                  },
                ),
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].price}",
                bold: true,
                size: 17,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text:
                    "${widget.controller.items[index].price * widget.controller.items[index].count}",
                bold: true,
                size: 17,
              ),
            ),
          ],
        );
      },
    );
  }
}
