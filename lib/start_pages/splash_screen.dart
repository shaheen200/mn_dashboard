import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mn1/start_pages/login_screen.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/funTool.dart';

class Splash extends StatefulWidget {
  final bool isEn;
  const Splash({super.key, required this.isEn});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      await dotenv.load(fileName: widget.isEn ? 'env/en.env' : 'env/ar.env');
      goToPage(context, const LoginScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CustomImage(path: "image/logo.png", w: 0.5, h: 1)),
    );
  }
}
