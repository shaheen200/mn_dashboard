import 'package:flutter/material.dart';
import 'package:mn1/database/home__base.dart';
import 'package:mn1/home/controller_home_page.dart';
import 'package:mn1/home/drawer_home_page.dart';
import 'package:mn1/home/home_page_screen_view.dart';
import 'package:mn1/tools/customText.dart';

class HomePage extends StatefulWidget {
  final int id;
  const HomePage({super.key, required this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ControllerHomePage controllerHomePage;

  @override
  void initState() {
    controllerHomePage = ControllerHomePage();
    super.initState();
  }

  @override
  void dispose() {
    controllerHomePage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;

    return FutureBuilder(
      future: HomeBase.get(id: widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            !snapshot.data!.success) {
          return Scaffold(
            body: Center(
              child: TEXT(
                text: snapshot.data?.msg ?? "حدث خطأ في تحميل البيانات",
                size: 18,
                bold: true,
                center: true,
              ),
            ),
          );
        } else {
          final openData = snapshot.data!.data!;
          controllerHomePage.init(openData: openData);

          return Scaffold(
            // استخدام Builder لحل مشكلة Context وفتح الـ Drawer بأمان في الموبايل
            appBar: !isDesktop
                ? AppBar(
                    elevation: 0,
                    leading: Builder(
                      builder: (scaffoldContext) => IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        onPressed: () {
                          Scaffold.of(scaffoldContext).openDrawer();
                        },
                      ),
                    ),
                    title: TEXT(text: openData.name, size: 18, bold: true),
                  )
                : null,
            // الـ Drawer يظهر عند السحب أو الضغط في الموبايل والتابلت
            drawer: !isDesktop
                ? SizedBox(
                    width: 280,
                    child: DrawerHomePage(
                      controllerHomePage: controllerHomePage,
                      openData: openData,
                    ),
                  )
                : null,
            body: Row(
              children: [
                // القائمة الجانبية تكون مثبتة على اليسار دائماً في الشاشات الكبيرة (Desktop)
                if (isDesktop)
                  SizedBox(
                    width: 280,
                    child: DrawerHomePage(
                      controllerHomePage: controllerHomePage,
                      openData: openData,
                    ),
                  ),
                // المحتوى الرئيسي يتوسع لملء باقي المساحة
                Expanded(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(16),
                    child: HomePageScreenView(
                      controllerHomePage: controllerHomePage,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
