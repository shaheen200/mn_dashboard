import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/home/screens/not_complete_order/accept_order/accept_order.dart';
import 'package:mn1/home/screens/not_complete_order/dialog/show_order_more_dialog.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/funTool.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';

class ShowNotCompleteOrderView extends StatefulWidget {
  final ApplicationController<Order> controller;
  final bool isDesktop;
  const ShowNotCompleteOrderView({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

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
      if (mounted) setState(() {});
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
      physics: const BouncingScrollPhysics(),
      itemCount: widget.controller.items.length,
      itemBuilder: (context, index) {
        final item = widget.controller.items[index];

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 40).clamp(0, 400)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 15 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: widget.isDesktop
              ? CustomBodyTable(
                  bodyData: [
                    CustomBodyTableItems(
                      flex: 1,
                      widget: TEXT(text: "${index + 1}", bold: true, size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.id}", bold: true, size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 4,
                      widget: TEXT(
                        text: "${item.userName}",
                        bold: true,
                        size: 15,
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(
                        color: Colors.amber,
                        text: "${item.statusText}",
                        bold: true,
                        size: 15,
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(
                        text: "${item.totalPrice}",
                        bold: true,
                        size: 15,
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.time}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.countGoods}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 1,
                      widget: CustomPop(
                        items: [
                          CustomPopItems(
                            text: getText('show_order'),
                            icon: Icons.visibility_rounded,
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
                            icon: Icons.info_outline_rounded,
                            onTap: () {
                              showOrderMoreDialog(context, order: item);
                            },
                          ),
                          CustomPopItems(
                            text: getText('by'),
                            icon: Icons.person_outline_rounded,
                            onTap: () {
                              byIdDialog(context: context, id: item.userId);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : CustomContainer(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(16),
                  radius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                child: TEXT(
                                  text: "${item.id}",
                                  size: 12,
                                  bold: true,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              TEXT(
                                text: "${item.userName}",
                                size: 16,
                                bold: true,
                              ),
                            ],
                          ),
                          CustomPop(
                            items: [
                              CustomPopItems(
                                text: getText('show_order'),
                                icon: Icons.visibility_rounded,
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
                                icon: Icons.info_outline_rounded,
                                onTap: () {
                                  showOrderMoreDialog(context, order: item);
                                },
                              ),
                              CustomPopItems(
                                text: getText('by'),
                                icon: Icons.person_outline_rounded,
                                onTap: () {
                                  byIdDialog(context: context, id: item.userId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TEXT(
                            color: Colors.amber,
                            text: "قيد الانتظار",
                            bold: true,
                            size: 14,
                          ),
                          TEXT(
                            text: "${item.totalPrice} 💰",
                            bold: true,
                            size: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.calendar_today_rounded,
                            "${item.time}",
                          ),
                          _buildInfoRow(
                            context,
                            Icons.inventory_2_outlined,
                            "${getText('count_goods')}: ${item.countGoods}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: Theme.of(context).primaryColorDark.withOpacity(0.6),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).primaryColorDark.withOpacity(0.8),
            fontFamily: "tajawal",
          ),
        ),
      ],
    );
  }
}
