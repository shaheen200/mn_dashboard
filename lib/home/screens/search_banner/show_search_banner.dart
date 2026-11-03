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

class _ShowSearchBannerState extends State<ShowSearchBanner>
    with SingleTickerProviderStateMixin {
  late ApplicationController<ImageBanner> controller;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    controller = ApplicationController<ImageBanner>();
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _buildHeaderContent(context, isDesktop),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildHeaderContent(context, isDesktop),
                ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                if (isDesktop)
                  CustomHeadTable(
                    headData: [
                      CustomHeadTableItems(flex: 1, text: getText('num')),
                      CustomHeadTableItems(flex: 2, text: getText('image')),
                      CustomHeadTableItems(flex: 2, text: getText('date')),
                      CustomHeadTableItems(flex: 2, text: getText('state')),
                      CustomHeadTableItems(flex: 1, text: getText('more')),
                    ],
                  ),
                if (isDesktop) const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder(
                    future: BannerImageBase.get(all: true),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!.success) {
                        return Center(
                          child: TEXT(
                            text:
                                snapshot.data?.msg ??
                                "حدث خطأ في تحميل البيانات",
                            size: 18,
                            bold: true,
                            center: true,
                          ),
                        );
                      } else {
                        controller.equal(snapshot.data!.data);
                        return ShowSearchBannerView(
                          controller: controller,
                          isDesktop: isDesktop,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderContent(BuildContext context, bool isDesktop) {
    return [
      TEXT(
        text: getText('search_banner'),
        size: isDesktop ? 26 : 22,
        bold: true,
        color: Theme.of(context).primaryColorDark,
      ),
      if (!isDesktop) const SizedBox(height: 12),
      CustomBtn(
        height: 48,
        raduis: 14,
        onClick: () {
          addBannerImageDialog(context, controller: controller);
        },
        text: getText('add_image'),
        w: isDesktop ? 0.15 : 1.0,
      ),
    ];
  }
}
