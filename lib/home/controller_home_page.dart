import 'package:flutter/material.dart';
import 'package:mn1/home/screens/clients/show/show_client.dart';
import 'package:mn1/home/screens/complete_order/show_complete_order.dart';
import 'package:mn1/home/screens/departs/show/show_depart.dart';
import 'package:mn1/home/screens/empolyee/show/show_empolyee.dart';
import 'package:mn1/home/screens/main/main_screen.dart';
import 'package:mn1/home/screens/not_complete_order/show_not_complete_order.dart';
import 'package:mn1/home/screens/offers/show/show_offers.dart';
import 'package:mn1/home/screens/reports/report_page.dart';
import 'package:mn1/home/screens/search_banner/show_search_banner.dart';
import 'package:mn1/home/screens/store/show/show_store.dart';
import 'package:mn1/models/open_data.dart';
import 'package:mn1/provider/language/get_text.dart';

class ControllerHomePage extends ChangeNotifier {
  List<HomePageScreens> screens = [];
  late HomePageScreens currentScreen;

  void init({required OpenData openData}) {
    screens = [
      HomePageScreens(
        show: true,
        id: 0,
        icon: Icons.dashboard_rounded,
        title: getText('main_screen'),
        screen: MainScreen(),
      ),
      HomePageScreens(
        show: openData.showEmp,
        id: 1,
        icon: Icons.badge_rounded,
        title: getText('emp'),
        screen: ShowEmpolyee(add: openData.addEmp),
      ),
      HomePageScreens(
        show: openData.showClient,
        id: 2,
        icon: Icons.people_alt_rounded,
        title: getText('client'),
        screen: ShowClient(add: openData.addClient),
      ),
      HomePageScreens(
        show: openData.showDepart,
        id: 3,
        icon: Icons.account_tree_rounded,
        title: getText('depart'),
        screen: ShowDepart(),
      ),
      HomePageScreens(
        show: openData.showStore,
        id: 4,
        icon: Icons.storefront_rounded,
        title: getText('store'),
        screen: ShowStore(),
      ),
      HomePageScreens(
        show: openData.showOffer,
        id: 5,
        icon: Icons.local_offer_rounded,
        title: getText('offer'),
        screen: ShowOffers(),
      ),
      HomePageScreens(
        show: openData.showCompleteOrder,
        id: 6,
        icon: Icons.task_alt_rounded,
        title: getText('complete_order'),
        screen: ShowCompleteOrder(),
      ),
      HomePageScreens(
        show: openData.showNotCompleteOrder,
        id: 7,
        icon: Icons.pending_actions_rounded,
        title: getText('not_complete_order'),
        screen: ShowNotCompleteOrder(),
      ),
      HomePageScreens(
        show: openData.report,
        id: 8,
        icon: Icons.analytics_rounded,
        title: getText('reports'),
        screen: ReportPage(),
      ),
      HomePageScreens(
        show: openData.role == UserRole.admin,
        id: 9,
        icon: Icons.image_rounded,
        title: getText('search_banner'),
        screen: ShowSearchBanner(),
      ),
    ];
    screens = screens.where((element) => element.show).toList();
    if (screens.isNotEmpty) {
      currentScreen = screens[0];
    }
    notifyListeners();
  }

  void change(int index) {
    // البحث عن الشاشة بالـ id لضمان الدقة بعد الفلترة
    final selected = screens.firstWhere(
      (element) => element.id == index,
      orElse: () => screens[0],
    );
    currentScreen = selected;
    notifyListeners();
  }
}

class HomePageScreens {
  final int id;
  final String title;
  final IconData icon;
  final Widget screen;
  final bool show;
  const HomePageScreens({
    required this.id,
    required this.icon,
    required this.title,
    required this.screen,
    required this.show,
  });
}
