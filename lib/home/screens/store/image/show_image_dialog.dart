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
            children: [
              Row(
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
              const SizedBox(height: 12),
              CustomHeadTable(
                headData: [
                  CustomHeadTableItems(flex: 1, text: getText('num')),
                  CustomHeadTableItems(flex: 2, text: getText('image')),
                  CustomHeadTableItems(flex: 2, text: getText('date')),
                  CustomHeadTableItems(flex: 1, text: getText('more')),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder(
                  future: StoreBase.getImage(id: good.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        !snapshot.data!.success) {
                      return Center(
                        child: TEXT(
                          text: snapshot.data?.msg ?? "حدث خطأ في تحميل الصور",
                          size: 18,
                          bold: true,
                          center: true,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.data.length,
                        itemBuilder: (context, index) {
                          final imageItem = snapshot.data!.data[index];
                          return CustomBodyTable(
                            bodyData: [
                              CustomBodyTableItems(
                                flex: 1,
                                widget: TEXT(
                                  text: "${index + 1}",
                                  bold: true,
                                  size: 15,
                                ),
                              ),
                              CustomBodyTableItems(
                                flex: 2,
                                widget: GestureDetector(
                                  onTap: () async {
                                    if ("${imageItem.url}".isNotEmpty) {
                                      final Uri url = Uri.parse(
                                        "${imageItem.url}",
                                      );
                                      await launchUrl(url);
                                    }
                                  },
                                  child: TEXT(
                                    color: Colors.blue,
                                    text: getText('tap_to_view'),
                                    bold: true,
                                    size: 15,
                                  ),
                                ),
                              ),
                              CustomBodyTableItems(
                                flex: 2,
                                widget: TEXT(
                                  text: "${imageItem.time}",
                                  size: 15,
                                ),
                              ),
                              CustomBodyTableItems(
                                flex: 1,
                                widget: CustomPop(
                                  items: [
                                    CustomPopItems(
                                      text: getText('by'),
                                      icon: Icons.visibility_rounded,
                                      onTap: () {
                                        byIdDialog(
                                          context: context,
                                          id: imageItem.byId,
                                        );
                                      },
                                    ),
                                    CustomPopItems(
                                      text: getText('delete'),
                                      icon: Icons.delete_rounded,
                                      onTap: () async {
                                        waiting(context: context);
                                        final delete =
                                            await StoreBase.deleteImage(
                                              id: imageItem.id,
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
