import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/user_base.dart';
import 'package:mn1/home/screens/clients/add/add_client_dialog.dart';
import 'package:mn1/home/screens/clients/show/show_client_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/user.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowClient extends StatefulWidget {
  final bool add;
  const ShowClient({super.key, required this.add});

  @override
  State<ShowClient> createState() => _ShowClientState();
}

class _ShowClientState extends State<ShowClient>
    with SingleTickerProviderStateMixin {
  late ApplicationController<User> controller;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    controller = ApplicationController<User>();
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
            width: isDesktop ? pageSizeWidth(context, 0.45) : double.infinity,
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
                      CustomHeadTableItems(flex: 4, text: getText('name')),
                      CustomHeadTableItems(flex: 2, text: getText('phone')),
                      CustomHeadTableItems(flex: 2, text: getText('address')),
                      CustomHeadTableItems(flex: 2, text: getText('date')),
                      CustomHeadTableItems(flex: 1, text: getText('more')),
                    ],
                  ),
                if (isDesktop) const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder(
                    future: UsersBase.getUsers(type: 'client'),
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
                        return ShowClientView(
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
            text: getText('client'),
            size: isDesktop ? 26 : 22,
            bold: true,
            color: Theme.of(context).primaryColorDark,
          ),
          const SizedBox(height: 4),
          Text(
            "إدارة ومتابعة بيانات العملاء",
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).primaryColorDark.withOpacity(0.6),
              fontFamily: "tajawal",
            ),
          ),
        ],
      ),
      if (!isDesktop) const SizedBox(height: 14),
      if (widget.add)
        CustomBtn(
          height: 48,
          raduis: 14,
          onClick: () {
            addClientDialog(context, controller: controller);
          },
          text: getText('create_client'),
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
        icon: Icons.phone_android_rounded,
        hintText: "${getText('phone')} ....",
        onChanged: (p0) {
          controller.search(p0, (p1) => p1.phone);
        },
      ),
    ];
  }
}
