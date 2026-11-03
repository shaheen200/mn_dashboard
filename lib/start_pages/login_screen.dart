// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:mn1/database/user_base.dart';
import 'package:mn1/home/home_page.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/start_pages/forget_pw/send_otp.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/funTool.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';
import '../tools/customText.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phone = TextEditingController();
  final TextEditingController pw = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    // phone.text = '966557183837';
    // pw.text = '966557183837admin';
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    phone.dispose();
    pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: isDesktop
                    ? _buildDesktopLayout(context)
                    : _buildMobileLayout(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: _buildFormContent(context),
            ),
          ),
        ),
        const SizedBox(width: 40),
        const Expanded(
          flex: 5,
          child: Center(
            child: CustomImage(path: "image/logo.png", w: 0.35, h: 0.55),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomImage(path: "image/logo.png", w: 0.35, h: 0.22),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: _buildFormContent(context),
        ),
      ],
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      radius: 24,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TEXT(
              text: getText("login"),
              size: 24,
              bold: true,
              color: Theme.of(context).primaryColorDark,
            ),
            const SizedBox(height: 6),
            Text(
              "مرحباً بك مجدداً، يرجى إدخال بيانات حسابك",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColorDark.withOpacity(0.6),
                fontFamily: "tajawal",
              ),
            ),
            const SizedBox(height: 28),
            CustomField(
              labelText: getText("phone"),
              hintText: getText("phone"),
              icon: Icons.phone_android_rounded,
              controller: phone,
              type: CustomFieldType.number,
              validator: (p0) => val(p0),
            ),
            const SizedBox(height: 18),
            CustomField(
              labelText: getText("pw"),
              hintText: getText("pw"),
              icon: Icons.lock_outline_rounded,
              pw: true,
              controller: pw,
              validator: (p0) => val(p0),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () => goPage(context, const SendOtp()),
                child: TEXT(
                  text: getText('forget_pw'),
                  size: 15,
                  bold: true,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomBtn(
              height: 52,
              raduis: 16,
              w: 1,
              onClick: () async {
                if (formKey.currentState!.validate()) {
                  waiting(context: context);
                  final login = await UsersBase.login(
                    phone: phone.text,
                    pw: pw.text,
                  );
                  pOP(context);
                  if (login.success) {
                    goToPage(context, HomePage(id: login.data));
                  } else {
                    msgDialog(context1: context, state: -1, text: login.msg);
                  }
                }
              },
              text: getText("login"),
            ),
          ],
        ),
      ),
    );
  }
}
