import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/offer_base.dart';
import 'package:mn1/models/offer.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';

class ShowOffersView extends StatefulWidget {
  final ApplicationController<Offer> controller;
  const ShowOffersView({super.key, required this.controller});

  @override
  State<ShowOffersView> createState() => _ShowOffersViewState();
}

class _ShowOffersViewState extends State<ShowOffersView> {
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
                text: "${widget.controller.items[index].goodName}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].goodCode}",
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
                text: "${widget.controller.items[index].fromDate}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].toDate}",
                bold: true,
                size: 16,
              ),
            ),

            CustomBodyTableItems(
              flex: 1,
              widget: CustomPop(
                items: [
                  CustomPopItems(
                    text: getText('delete'),
                    onTap: () {
                      msgDialog(
                        context1: context,
                        state: 0,
                        text: getText('delete_msg'),
                        onClick: () async {
                          pOP(context);
                          waiting(context: context);
                          final delete = await OfferBase.delete(
                            id: widget.controller.items[index].id,
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
        );
      },
    );
  }
}
