import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/store_base.dart';
import 'package:mn1/home/screens/store/add/add_good_dialog.dart';
import 'package:mn1/home/screens/store/show/show_store_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowStore extends StatefulWidget {
  const ShowStore({super.key});

  @override
  State<ShowStore> createState() => _ShowStoreState();
}

class _ShowStoreState extends State<ShowStore>
    with SingleTickerProviderStateMixin {
  late ApplicationController<Good> controller;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    controller = ApplicationController<Good>();
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
          SizedBox(
            width: isDesktop ? pageSizeWidth(context, 0.5) : double.infinity,
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(child: _buildSearchFields()[0]),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSearchFields()[1]),
                    ],
                  )
                : Column(
                    children: [
                      _buildSearchFields()[0],
                      const SizedBox(height: 12),
                      _buildSearchFields()[1],
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                if (isDesktop)
                  CustomHeadTable(
                    headData: [
                      CustomHeadTableItems(flex: 1, text: getText('num')),
                      CustomHeadTableItems(flex: 4, text: getText('good_name')),
                      CustomHeadTableItems(flex: 2, text: getText('code')),
                      CustomHeadTableItems(flex: 2, text: getText('price')),
                      CustomHeadTableItems(flex: 2, text: getText('date')),
                      CustomHeadTableItems(flex: 2, text: getText('exist')),
                      CustomHeadTableItems(flex: 2, text: getText('state')),
                      CustomHeadTableItems(flex: 1, text: getText('more')),
                    ],
                  ),
                if (isDesktop) const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder(
                    future: StoreBase.get(all: true),
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
                        return ShowStoreView(
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TEXT(
            text: getText('store'),
            size: isDesktop ? 26 : 22,
            bold: true,
            color: Theme.of(context).primaryColorDark,
          ),
          const SizedBox(height: 4),
          Text(
            "إدارة المخزن والمنتجات",
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).primaryColorDark.withOpacity(0.6),
              fontFamily: "tajawal",
            ),
          ),
        ],
      ),
      if (!isDesktop) const SizedBox(height: 14),
      CustomBtn(
        height: 48,
        raduis: 14,
        onClick: () {
          addGoodDialog(context, controller: controller);
        },
        text: getText('create_good'),
        w: isDesktop ? 0.15 : 1.0,
      ),
    ];
  }

  List<Widget> _buildSearchFields() {
    return [
      CustomField(
        icon: Icons.search_rounded,
        hintText: "${getText('name')} ....",
        onChanged: (p0) {
          controller.search(p0, (p1) => p1.name);
        },
      ),
      CustomField(
        icon: Icons.numbers_rounded,
        hintText: "${getText('code')} ....",
        onChanged: (p0) {
          controller.search(p0, (p1) => p1.code.toString());
        },
      ),
    ];
  }
}
