import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/order_base.dart';
import 'package:mn1/home/screens/not_complete_order/show_not_complete_order_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowNotCompleteOrder extends StatefulWidget {
  const ShowNotCompleteOrder({super.key});

  @override
  State<ShowNotCompleteOrder> createState() => _ShowNotCompleteOrderState();
}

class _ShowNotCompleteOrderState extends State<ShowNotCompleteOrder>
    with SingleTickerProviderStateMixin {
  String startDate = DateTime.now()
      .subtract(const Duration(days: 4))
      .toString()
      .split(' ')[0];
  String endDate = DateTime.now()
      .add(const Duration(days: 2))
      .toString()
      .split(' ')[0];
  late ApplicationController<Order> controller;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    controller = ApplicationController<Order>();
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TEXT(
            text: getText('not_complete_order'),
            size: isDesktop ? 26 : 22,
            bold: true,
            color: Theme.of(context).primaryColorDark,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: isDesktop ? pageSizeWidth(context, 0.6) : double.infinity,
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(child: _buildSearchFields()[0]),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSearchFields()[1]),
                    ],
                  )
                : Column(
                    children: [
                      _buildSearchFields()[0],
                      const SizedBox(height: 12),
                      _buildSearchFields()[1],
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                if (isDesktop)
                  CustomHeadTable(
                    headData: [
                      CustomHeadTableItems(flex: 1, text: getText('num')),
                      CustomHeadTableItems(
                        flex: 2,
                        text: getText('order_number'),
                      ),
                      CustomHeadTableItems(
                        flex: 4,
                        text: getText('client_name'),
                      ),
                      CustomHeadTableItems(flex: 2, text: getText('state')),
                      CustomHeadTableItems(flex: 2, text: getText('price')),
                      CustomHeadTableItems(flex: 2, text: getText('date')),
                      CustomHeadTableItems(
                        flex: 2,
                        text: getText('count_goods'),
                      ),
                      CustomHeadTableItems(flex: 1, text: getText('more')),
                    ],
                  ),
                if (isDesktop) const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder(
                    future: OrderBase.getOrder(
                      userId: 0,
                      startDate: startDate,
                      endDate: endDate,
                      status: OrderStatus.un_complete,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!.success) {
                        return Center(
                          child: TEXT(
                            text:
                                snapshot.data?.msg ??
                                "حدث خطأ في تحميل الطلبات غير المكتملة",
                            size: 18,
                            bold: true,
                            center: true,
                          ),
                        );
                      } else {
                        controller.equal(snapshot.data!.data);
                        return ShowNotCompleteOrderView(
                          controller: controller,
                          isDesktop: isDesktop,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchFields() {
    return [
      CustomField(
        icon: Icons.search_rounded,
        hintText: "${getText('client_name')} ....",
        onChanged: (p0) {
          controller.search(p0, (p1) => p1.userName.toString());
        },
      ),
      CustomField(
        icon: Icons.numbers_rounded,
        hintText: "${getText('order_number')} ....",
        onChanged: (p0) {
          controller.search(p0, (p1) => p1.id.toString());
        },
      ),
    ];
  }
}
