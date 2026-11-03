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

class _AcceptOrderState extends State<AcceptOrder>
    with SingleTickerProviderStateMixin {
  late ApplicationController<OrderGood> controller;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    controller = ApplicationController<OrderGood>();
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getText('show_order'),
          style: const TextStyle(
            fontFamily: 'tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: OrderBase.getOrderGoods(
              orderId: widget.orderController.items[widget.indexOrder].id,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  !snapshot.data!.success) {
                return Center(
                  child: TEXT(
                    text: snapshot.data?.msg ?? "حدث خطأ في تحميل محتوى الطلب",
                    size: 18,
                    bold: true,
                    center: true,
                  ),
                );
              } else {
                controller.equal(snapshot.data!.data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // أزرار القبول والرفض متجاوبة
                    Visibility(
                      visible: widget.edit,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: isDesktop
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: _buildActionButtons(context),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _buildActionButtons(context)[0],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildActionButtons(context)[1],
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (isDesktop)
                      CustomHeadTable(
                        headData: [
                          CustomHeadTableItems(flex: 1, text: getText('num')),
                          CustomHeadTableItems(
                            flex: 3,
                            text: getText('good_name'),
                          ),
                          CustomHeadTableItems(
                            flex: 2,
                            text: getText('depart'),
                          ),
                          CustomHeadTableItems(flex: 2, text: getText('count')),
                          CustomHeadTableItems(flex: 2, text: getText('price')),
                          CustomHeadTableItems(flex: 2, text: getText('total')),
                        ],
                      ),
                    if (isDesktop) const SizedBox(height: 12),
                    Expanded(
                      child: AcceptOrderView(
                        controller: controller,
                        edit: widget.edit,
                        isDesktop: isDesktop,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    return [
      CustomBtn(
        height: 48,
        raduis: 14,
        btnColor: Colors.redAccent.shade700,
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
        w: MediaQuery.of(context).size.width > 900 ? 0.15 : 1.0,
      ),
      const SizedBox(width: 12),
      CustomBtn(
        height: 48,
        raduis: 14,
        btnColor: Colors.teal.shade700,
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
        w: MediaQuery.of(context).size.width > 900 ? 0.15 : 1.0,
      ),
    ];
  }
}
