import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/banner_image_base.dart';
import 'package:mn1/home/screens/search_banner/add_search_banner_dialog.dart';
import 'package:mn1/models/image_banner.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';

import 'show_search_banner_view.dart';

class ShowSearchBanner extends StatefulWidget {
  const ShowSearchBanner({super.key});

  @override
  State<ShowSearchBanner> createState() => _ShowSearchBannerState();
}

class _ShowSearchBannerState extends State<ShowSearchBanner> {
  late ApplicationController<ImageBanner> controller;

  @override
  void initState() {
    controller = .new();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        Row(
          crossAxisAlignment: .center,
          spacing: 20,
          children: [
            Expanded(
              child: TEXT(text: getText('search_banner'), size: 25, bold: true),
            ),
            CustomBtn(
              onClick: () {
                addBannerImageDialog(context, controller: controller);
              },
              text: getText('add_image'),
              w: 0.2,
            ),
          ],
        ),

        Expanded(
          child: Column(
            children: [
              CustomHeadTable(
                headData: [
                  CustomHeadTableItems(flex: 1, text: getText('num')),
                  CustomHeadTableItems(flex: 2, text: getText('image')),
                  CustomHeadTableItems(flex: 2, text: getText('date')),
                  CustomHeadTableItems(flex: 2, text: getText('state')),
                  CustomHeadTableItems(flex: 1, text: getText('more')),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: BannerImageBase.get(all: true),
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
                      controller.equal(snapshot.data!.data);
                      return ShowSearchBannerView(controller: controller);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
