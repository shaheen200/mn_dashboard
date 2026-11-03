import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/offer_base.dart';
import 'package:mn1/models/offer.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';

class ShowOffersView extends StatefulWidget {
  final ApplicationController<Offer> controller;
  final bool isDesktop;
  const ShowOffersView({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

  @override
  State<ShowOffersView> createState() => _ShowOffersViewState();
}

class _ShowOffersViewState extends State<ShowOffersView> {
  @override
  void initState() {
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
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
                      flex: 4,
                      widget: TEXT(
                        text: "${item.goodName}",
                        bold: true,
                        size: 15,
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.goodCode}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.price}", bold: true, size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.fromDate}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.toDate}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 1,
                      widget: CustomPop(
                        items: [
                          CustomPopItems(
                            text: getText('delete'),
                            icon: Icons.delete_rounded,
                            onTap: () {
                              msgDialog(
                                context1: context,
                                state: 0,
                                text: getText('delete_msg'),
                                onClick: () async {
                                  pOP(context);
                                  waiting(context: context);
                                  final delete = await OfferBase.delete(
                                    id: item.id,
                                  );
                                  pOP(context);
                                  if (delete.success) {
                                    widget.controller.delete(index);
                                  }
                                  msgDialog(
                                    context1: context,
                                    state: delete.success ? 1 : -1,
                                    text: delete.msg,
                                  );
                                },
                              );
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
                                  text: "${index + 1}",
                                  size: 13,
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
                          CustomPop(
                            items: [
                              CustomPopItems(
                                text: getText('delete'),
                                icon: Icons.delete_rounded,
                                onTap: () {
                                  msgDialog(
                                    context1: context,
                                    state: 0,
                                    text: getText('delete_msg'),
                                    onClick: () async {
                                      pOP(context);
                                      waiting(context: context);
                                      final delete = await OfferBase.delete(
                                        id: item.id,
                                      );
                                      pOP(context);
                                      if (delete.success) {
                                        widget.controller.delete(index);
                                      }
                                      msgDialog(
                                        context1: context,
                                        state: delete.success ? 1 : -1,
                                        text: delete.msg,
                                      );
                                    },
                                  );
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
                          _buildInfoRow(
                            context,
                            Icons.qr_code_rounded,
                            "${getText('code')}: ${item.goodCode}",
                          ),
                          TEXT(
                            text: "${item.price} 💰",
                            size: 15,
                            bold: true,
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
                            Icons.date_range_rounded,
                            "${getText('from')}: ${item.fromDate}",
                          ),
                          _buildInfoRow(
                            context,
                            Icons.date_range_rounded,
                            "${getText('to')}: ${item.toDate}",
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
