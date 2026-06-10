import 'package:flutter/material.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: CustomImage(path: 'image/logo.png', w: 0.6, h: 0.6));
  }
}
