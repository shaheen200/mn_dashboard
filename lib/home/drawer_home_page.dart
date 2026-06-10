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
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      // width: pageSizeWidth(context, 0.3),
      shadowColor: Theme.of(context).shadowColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 12,
          children: [
            const CustomImage(path: "image/logo.png", w: 0.1, h: 0.13),
            TEXT(text: "${widget.openData.name}", size: 20, bold: true),
            TEXT(
              text: widget.openData.role == UserRole.admin
                  ? getText('admin')
                  : getText('emp'),
              size: 17,
            ),

            Expanded(
              child: ListView(
                children: widget.controllerHomePage.screens.map((e) {
                  return GestureDetector(
                    onTap: () {
                      widget.controllerHomePage.change(e.id);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 6,
                        bottom: 6,
                      ),
                      margin: EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            e.id == widget.controllerHomePage.currentScreen.id
                            ? Theme.of(context).primaryColor.withOpacity(0.25)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Row(
                        crossAxisAlignment: .center,
                        mainAxisAlignment: .start,
                        spacing: 15,
                        children: [
                          Icon(
                            e.icon,
                            color:
                                e.id ==
                                    widget.controllerHomePage.currentScreen.id
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).shadowColor,
                          ),
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              child: Text(e.title),
                              duration: Duration(milliseconds: 500),
                              style: TextStyle(
                                fontSize: 20,
                                color:
                                    e.id ==
                                        widget
                                            .controllerHomePage
                                            .currentScreen
                                            .id
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).shadowColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            CustomBtn(
              onClick: () async {
                await LocalBase.clearOpenData();
                goToPage2(context, LoginScreen());
              },
              text: getText('logout'),
              w: 1,
            ),
          ],
        ),
      ),
    );
  }
}
