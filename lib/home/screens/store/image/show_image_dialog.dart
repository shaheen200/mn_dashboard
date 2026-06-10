import 'package:flutter/material.dart';
import 'package:mn1/database/store_base.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/home/screens/store/image/add_image_dialog.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';
import 'package:url_launcher/url_launcher.dart';

void showGoodImageDialog({required BuildContext context, required Good good}) {
  customDialog(
    context: context,
    width: 0.7,
    child: StatefulBuilder(
      builder: (con, update) {
        return SizedBox(
          width: pageSizeWidth(context, 0.7),
          height: pageSizeHeight(context, 0.75),
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 12,
                crossAxisAlignment: .center,
                children: [
                  Expanded(
                    child: TEXT(
                      text: getText('show_image'),
                      size: 20,
                      bold: true,
                    ),
                  ),
                  CustomBtn(
                    onClick: () async {
                      await addImageDialog(context: context, good: good);
                      update(() {});
                    },
                    text: getText('add_image'),
                    w: 0.15,
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).primaryColorDark,
                height: 25,
                thickness: 2,
              ),
              CustomHeadTable(
                headData: [
                  CustomHeadTableItems(flex: 1, text: getText('num')),
                  CustomHeadTableItems(flex: 2, text: getText('image')),
                  CustomHeadTableItems(flex: 2, text: getText('date')),
                  CustomHeadTableItems(flex: 1, text: getText('more')),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: StoreBase.getImage(id: good.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!snapshot.data!.success) {
                      return Center(
                        child: TEXT(
                          text: snapshot.data!.msg,
                          size: 20,
                          bold: true,
                          center: true,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.data.length,
                        itemBuilder: (context, index) {
                          return CustomBodyTable(
                            bodyData: [
                              CustomBodyTableItems(
                                flex: 1,
                                widget: TEXT(
                                  text: "${index + 1}",
                                  bold: true,
                                  size: 16,
                                ),
                              ),
                              CustomBodyTableItems(
                                flex: 2,
                                widget: GestureDetector(
                                  onTap: () async {
                                    if ("${snapshot.data!.data[index].url}"
                                        .isNotEmpty) {
                                      final Uri _url = Uri.parse(
                                        "${snapshot.data!.data[index].url}",
                                      );
                                      await launchUrl(_url);
                                    }
                                  },
                                  child: TEXT(
                                    color: Colors.blue,
                                    text: getText('tap_to_view'),
                                    bold: true,
                                    size: 16,
                                  ),
                                ),
                              ),
                              CustomBodyTableItems(
                                flex: 2,
                                widget: TEXT(
                                  text: "${snapshot.data!.data[index].time}",
                                  bold: true,
                                  size: 16,
                                ),
                              ),

                              CustomBodyTableItems(
                                flex: 1,
                                widget: CustomPop(
                                  items: [
                                    CustomPopItems(
                                      text: getText('by'),
                                      onTap: () {
                                        byIdDialog(
                                          context: context,
                                          id: snapshot.data!.data[index].byId,
                                        );
                                      },
                                    ),
                                    CustomPopItems(
                                      text: getText('delete'),
                                      onTap: () async {
                                        waiting(context: context);
                                        final delete =
                                            await StoreBase.deleteImage(
                                              id: snapshot.data!.data[index].id,
                                            );
                                        pOP(context);
                                        if (delete.success) {
                                          update(() {});
                                        } else {
                                          msgDialog(
                                            context1: context,
                                            state: -1,
                                            text: delete.msg,
                                          );
                                        }
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
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
