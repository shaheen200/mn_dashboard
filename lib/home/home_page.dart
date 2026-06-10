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
    controllerHomePage = .new();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: HomeBase.get(id: widget.id),
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
            controllerHomePage.init(openData: snapshot.data!.data!);
            return Row(
              children: [
                DrawerHomePage(
                  controllerHomePage: controllerHomePage,
                  openData: snapshot.data!.data!,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: HomePageScreenView(
                      controllerHomePage: controllerHomePage,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
