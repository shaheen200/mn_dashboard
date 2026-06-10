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
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';

class ShowStoreView extends StatefulWidget {
  final ApplicationController<Good> controller;
  const ShowStoreView({super.key, required this.controller});

  @override
  State<ShowStoreView> createState() => _ShowStoreViewState();
}

class _ShowStoreViewState extends State<ShowStoreView> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
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
              flex: 4,
              widget: TEXT(
                text: "${widget.controller.items[index].name}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].code}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].price}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].time}",
                bold: true,
                size: 16,
              ),
            ),

            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].exist}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: Switch(
                value: widget.controller.items[index].isActive,
                onChanged: (value) async {
                  waiting(context: context);
                  final create = await StoreBase.update(
                    id: widget.controller.items[index].id,
                    isActive: value.toString(),
                  );
                  pOP(context);
                  if (create.success) {
                    widget.controller.editItem(
                      create.data!,
                      (p0, p1) => p0.id == p1.id,
                    );
                  } else {
                    msgDialog(context1: context, state: -1, text: create.msg);
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
                    onTap: () {
                      editGoodDialog(
                        context,
                        controller: widget.controller,
                        index: index,
                      );
                    },
                  ),
                  CustomPopItems(
                    text: getText('show_image'),
                    onTap: () {
                      showGoodImageDialog(
                        context: context,
                        good: widget.controller.items[index],
                      );
                    },
                  ),
                  CustomPopItems(
                    text: getText('add_offer'),
                    onTap: () {
                      addOfferDialog(
                        context,
                        good: widget.controller.items[index],
                      );
                    },
                  ),
                  CustomPopItems(
                    text: getText('offer'),
                    onTap: () {
                      customDialog(
                        context: context,
                        width: pageSizeWidth(context, 0.9),
                        child: SizedBox(
                          height: pageSizeHeight(context, 0.75),
                          width: pageSizeWidth(context, 0.9),
                          child: ShowOffers(
                            id: widget.controller.items[index].id,
                          ),
                        ),
                      );
                    },
                  ),
                  CustomPopItems(
                    text: getText('by'),
                    onTap: () {
                      byIdDialog(
                        context: context,
                        id: widget.controller.items[index].byId,
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
