import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mn1/provider/change.dart';
import 'package:mn1/provider/theme/dark.dart';
import 'package:mn1/provider/theme/light.dart';
import 'package:mn1/start_pages/splash_screen.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MnStoreDashboard());
}

class MnStoreDashboard extends StatefulWidget {
  const MnStoreDashboard({super.key});
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MnStoreDashboardState>()?.restartApp();
  }

  @override
  State<MnStoreDashboard> createState() => _MnStoreDashboardState();
}

class _MnStoreDashboardState extends State<MnStoreDashboard> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey(); // Force rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChangeProvider(),
      builder: (context, child) {
        final provider = Provider.of<ChangeProvider>(context);
        return KeyedSubtree(
          key: _key,
          child: KeyedSubtree(
            child: MaterialApp(
              localizationsDelegates: const <LocalizationsDelegate<Object>>[
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
              localeResolutionCallback: (locales, supportedLocales) {
                return provider.language
                    ? supportedLocales.first
                    : supportedLocales.last;
              },
              localeListResolutionCallback: (locales, supportedLocales) {
                return provider.language
                    ? supportedLocales.first
                    : supportedLocales.last;
              },
              debugShowCheckedModeBanner: false,
              title: 'MN Store',
              theme: provider.darkMode ? dartTheme : lightTheme,
              home: Splash(isEn: provider.language),
            ),
          ),
        );
      },
    );
  }
}
