import 'package:flutter/material.dart';
import 'package:mn1/home/controller_home_page.dart';

class HomePageScreenView extends StatefulWidget {
  final ControllerHomePage controllerHomePage;
  const HomePageScreenView({super.key, required this.controllerHomePage});

  @override
  State<HomePageScreenView> createState() => _HomePageScreenViewState();
}

class _HomePageScreenViewState extends State<HomePageScreenView> {
  @override
  void initState() {
    widget.controllerHomePage.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controllerHomePage.currentScreen.screen;
  }
}
