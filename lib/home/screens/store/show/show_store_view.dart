import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/store_base.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/home/screens/offers/add/add_offer_dialog.dart';
import 'package:mn1/home/screens/offers/show/show_offers.dart';
import 'package:mn1/home/screens/store/edit/edit_goods_dialog.dart';
import 'package:mn1/home/screens/store/image/show_image_dialog.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';

class ShowStoreView extends StatefulWidget {
  final ApplicationController<Good> controller;
  final bool isDesktop;
  const ShowStoreView({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

  @override
  State<ShowStoreView> createState() => _ShowStoreViewState();
}

class _ShowStoreViewState extends State<ShowStoreView> {
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
                      widget: TEXT(text: "${item.name}", bold: true, size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.code}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.price}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.time}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.exist}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: Switch(
                        value: item.isActive,
                        onChanged: (value) async {
                          waiting(context: context);
                          final create = await StoreBase.update(
                            id: item.id,
                            isActive: value.toString(),
                          );
                          pOP(context);
                          if (create.success) {
                            widget.controller.editItem(
                              create.data!,
                              (p0, p1) => p0.id == p1.id,
                            );
                          } else {
                            msgDialog(
                              context1: context,
                              state: -1,
                              text: create.msg,
                            );
                          }
                        },
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 1,
                      widget: CustomPop(
                        items: [
                          CustomPopItems(
                            text: getText('edit'),
                            icon: Icons.edit_rounded,
                            onTap: () {
                              editGoodDialog(
                                context: context,
                                controller: widget.controller,
                                index: index,
                              );
                            },
                          ),
                          CustomPopItems(
                            text: getText('show_image'),
                            icon: Icons.image_rounded,
                            onTap: () {
                              showGoodImageDialog(context: context, good: item);
                            },
                          ),
                          CustomPopItems(
                            text: getText('add_offer'),
                            icon: Icons.local_offer_rounded,
                            onTap: () {
                              addOfferDialog(context, good: item);
                            },
                          ),
                          CustomPopItems(
                            text: getText('offer'),
                            icon: Icons.local_activity_rounded,
                            onTap: () {
                              customDialog(
                                context: context,
                                width: 0.9,
                                child: SizedBox(
                                  height: pageSizeHeight(context, 0.75),
                                  child: ShowOffers(id: item.id),
                                ),
                              );
                            },
                          ),
                          CustomPopItems(
                            text: getText('by'),
                            icon: Icons.visibility_rounded,
                            onTap: () {
                              byIdDialog(context: context, id: item.byId);
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
                              TEXT(text: "${item.name}", size: 16, bold: true),
                            ],
                          ),
                          CustomPop(
                            items: [
                              CustomPopItems(
                                text: getText('edit'),
                                icon: Icons.edit_rounded,
                                onTap: () {
                                  editGoodDialog(
                                    context: context,
                                    controller: widget.controller,
                                    index: index,
                                  );
                                },
                              ),
                              CustomPopItems(
                                text: getText('show_image'),
                                icon: Icons.image_rounded,
                                onTap: () {
                                  showGoodImageDialog(
                                    context: context,
                                    good: item,
                                  );
                                },
                              ),
                              CustomPopItems(
                                text: getText('add_offer'),
                                icon: Icons.local_offer_rounded,
                                onTap: () {
                                  addOfferDialog(context, good: item);
                                },
                              ),
                              CustomPopItems(
                                text: getText('offer'),
                                icon: Icons.local_activity_rounded,
                                onTap: () {
                                  customDialog(
                                    context: context,
                                    width: 0.9,
                                    child: SizedBox(
                                      height: pageSizeHeight(context, 0.75),
                                      child: ShowOffers(id: item.id),
                                    ),
                                  );
                                },
                              ),
                              CustomPopItems(
                                text: getText('by'),
                                icon: Icons.visibility_rounded,
                                onTap: () {
                                  byIdDialog(context: context, id: item.byId);
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
                            "${getText('code')}: ${item.code}",
                          ),
                          _buildInfoRow(
                            context,
                            Icons.monetization_on_outlined,
                            "${getText('price')}: ${item.price}",
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.inventory_2_outlined,
                            "${getText('exist')}: ${item.exist}",
                          ),
                          Switch(
                            value: item.isActive,
                            onChanged: (value) async {
                              waiting(context: context);
                              final create = await StoreBase.update(
                                id: item.id,
                                isActive: value.toString(),
                              );
                              pOP(context);
                              if (create.success) {
                                widget.controller.editItem(
                                  create.data!,
                                  (p0, p1) => p0.id == p1.id,
                                );
                              } else {
                                msgDialog(
                                  context1: context,
                                  state: -1,
                                  text: create.msg,
                                );
                              }
                            },
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
