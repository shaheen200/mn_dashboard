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

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد الأنيميشن الحركي للشعار (تكبير تدريجي مع ظهور ناعم)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // الانتقال بعد انتهاء الـ Timer مع تحميل الـ Dotenv بنجاح
    Timer(const Duration(seconds: 2), () async {
      await dotenv.load(fileName: widget.isEn ? 'env/en.env' : 'env/ar.env');
      if (mounted) {
        goToPage(context, const LoginScreen());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const CustomImage(path: "image/logo.png", w: 0.4, h: 0.4),
          ),
        ),
      ),
    );
  }
}
