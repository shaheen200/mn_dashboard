import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/banner_image_base.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/models/image_banner.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowSearchBannerView extends StatefulWidget {
  final ApplicationController<ImageBanner> controller;
  const ShowSearchBannerView({super.key, required this.controller});

  @override
  State<ShowSearchBannerView> createState() => _ShowSearchBannerViewState();
}

class _ShowSearchBannerViewState extends State<ShowSearchBannerView> {
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
              flex: 2,
              widget: GestureDetector(
                onTap: () async {
                  await launchUrl(
                    Uri.parse(widget.controller.items[index].url),
                  );
                },
                child: TEXT(
                  text: getText('tap_to_view'),
                  bold: true,
                  size: 16,
                  color: Colors.blue,
                ),
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
              widget: Switch(
                value: widget.controller.items[index].isActive,
                onChanged: (value) async {
                  waiting(context: context);
                  final create = await BannerImageBase.edit(
                    id: widget.controller.items[index].id,
                    isActive: value,
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
                    text: getText('delete'),
                    onTap: () async {
                      waiting(context: context);
                      final delete = await BannerImageBase.delete(
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
