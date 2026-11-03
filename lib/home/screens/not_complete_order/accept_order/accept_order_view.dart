import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/models/order_good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class AcceptOrderView extends StatefulWidget {
  final ApplicationController<OrderGood> controller;
  final bool edit;
  final bool isDesktop;
  const AcceptOrderView({
    super.key,
    required this.controller,
    required this.edit,
    required this.isDesktop,
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
                      flex: 3,
                      widget: TEXT(
                        text: "${item.goodName}",
                        bold: true,
                        size: 15,
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.departName}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: Visibility(
                        visible: widget.edit,
                        replacement: TEXT(
                          text: "${item.count}",
                          bold: true,
                          size: 15,
                        ),
                        child: CustomField(
                          type: CustomFieldType.number,
                          icon: Icons.numbers_rounded,
                          controller: TextEditingController(
                            text: item.count.toString(),
                          ),
                          onFieldSubmitted: (p0) {
                            widget.controller.editItem(
                              OrderGood(
                                id: item.id,
                                orderId: item.orderId,
                                goodId: item.goodId,
                                price: item.price,
                                count: num.parse(p0),
                                time: item.time,
                                totalPrice: item.totalPrice,
                                goodName: item.goodName,
                                departName: item.departName,
                              ),
                              (p0, p1) => p0.id == p1.id,
                            );
                          },
                        ),
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.price}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(
                        text: "${item.price * item.count}",
                        bold: true,
                        size: 15,
                        color: Theme.of(context).primaryColor,
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
                                  text: "${index + 1}",
                                  size: 12,
                                  bold: true,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              TEXT(
                                text: "${item.goodName}",
                                size: 16,
                                bold: true,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TEXT(
                              text: "${item.departName}",
                              size: 12,
                              bold: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.monetization_on_outlined,
                            "${getText('price')}: ${item.price}",
                          ),
                          TEXT(
                            text:
                                "${getText('total')}: ${item.price * item.count} 💰",
                            bold: true,
                            size: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TEXT(
                            text: "${getText('count')}:",
                            bold: true,
                            size: 14,
                          ),
                          SizedBox(
                            width: 120,
                            child: Visibility(
                              visible: widget.edit,
                              replacement: TEXT(
                                text: "${item.count}",
                                bold: true,
                                size: 14,
                              ),
                              child: CustomField(
                                type: CustomFieldType.number,
                                icon: Icons.numbers_rounded,
                                controller: TextEditingController(
                                  text: item.count.toString(),
                                ),
                                onFieldSubmitted: (p0) {
                                  widget.controller.editItem(
                                    OrderGood(
                                      id: item.id,
                                      orderId: item.orderId,
                                      goodId: item.goodId,
                                      price: item.price,
                                      count: num.parse(p0),
                                      time: item.time,
                                      totalPrice: item.totalPrice,
                                      goodName: item.goodName,
                                      departName: item.departName,
                                    ),
                                    (p0, p1) => p0.id == p1.id,
                                  );
                                },
                              ),
                            ),
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
