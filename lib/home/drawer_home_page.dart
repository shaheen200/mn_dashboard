import 'package:flutter/material.dart';
import 'package:mn1/database/local_base.dart';
import 'package:mn1/home/controller_home_page.dart';
import 'package:mn1/models/open_data.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/start_pages/login_screen.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/funTool.dart';

class DrawerHomePage extends StatefulWidget {
  final ControllerHomePage controllerHomePage;
  final OpenData openData;
  const DrawerHomePage({
    super.key,
    required this.controllerHomePage,
    required this.openData,
  });

  @override
  State<DrawerHomePage> createState() => _DrawerHomePageState();
}

class _DrawerHomePageState extends State<DrawerHomePage> {
  @override
  void initState() {
    widget.controllerHomePage.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      elevation: 0,
      backgroundColor: theme.cardColor,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.dividerColor.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // الترتيب الجديد: صف يضم اللوجو وبجانبه عمود الاسم والوظيفة
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. اللوجو داخل إطار دائري أنيق
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    width: 70,
                    height: 70,
                    child: const CustomImage(
                      path: "image/logo.png",
                      w: 1,
                      h: 1,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. عمود يضم الاسم وتحته الوظيفة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TEXT(
                          text: "${widget.openData.name}",
                          size: 16,
                          bold: true,
                          color: theme.primaryColorDark,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.openData.role == UserRole.admin
                                ? getText('admin')
                                : getText('emp'),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "tajawal",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(color: theme.dividerColor.withOpacity(0.15)),
              const SizedBox(height: 10),

              // قائمة الشاشات الجانبية بالأنيميشن الموحد
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: widget.controllerHomePage.screens.map((e) {
                    final bool isSelected =
                        e.id == widget.controllerHomePage.currentScreen.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            widget.controllerHomePage.change(e.id);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.primaryColor.withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  e.icon,
                                  size: 22,
                                  color: isSelected
                                      ? theme.primaryColor
                                      : theme.primaryColorDark.withOpacity(0.6),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    e.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? theme.primaryColor
                                          : theme.primaryColorDark.withOpacity(
                                              0.8,
                                            ),
                                      fontFamily: "tajawal",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: theme.dividerColor.withOpacity(0.15)),
              const SizedBox(height: 10),

              // زر تسجيل الخروج
              CustomBtn(
                height: 48,
                raduis: 16,
                btnColor: Colors.redAccent.shade700,
                onClick: () async {
                  await LocalBase.clearOpenData();
                  if (context.mounted) {
                    goToPage2(context, const LoginScreen());
                  }
                },
                text: getText('logout'),
                w: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
