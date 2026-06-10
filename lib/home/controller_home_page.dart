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
        icon: Icons.people,
        title: getText('main_screen'),
        screen: MainScreen(),
      ),
      HomePageScreens(
        show: openData.showEmp,
        id: 1,
        icon: Icons.people,
        title: getText('emp'),
        screen: ShowEmpolyee(add: openData.addEmp),
      ),
      HomePageScreens(
        show: openData.showClient,
        id: 2,
        icon: Icons.people_outline,
        title: getText('client'),
        screen: ShowClient(add: openData.addClient),
      ),
      HomePageScreens(
        show: openData.showDepart,
        id: 3,
        icon: Icons.data_exploration_outlined,
        title: getText('depart'),
        screen: ShowDepart(),
      ),
      HomePageScreens(
        show: openData.showStore,
        id: 4,
        icon: Icons.store,
        title: getText('store'),
        screen: ShowStore(),
      ),

      HomePageScreens(
        show: openData.showOffer,
        id: 5,
        icon: Icons.local_offer,
        title: getText('offer'),
        screen: ShowOffers(),
      ),
      HomePageScreens(
        show: openData.showCompleteOrder,
        id: 6,
        icon: Icons.online_prediction_rounded,
        title: getText('complete_order'),
        screen: ShowCompleteOrder(),
      ),
      HomePageScreens(
        show: openData.showNotCompleteOrder,
        id: 7,
        icon: Icons.done_all_outlined,
        title: getText('not_complete_order'),
        screen: ShowNotCompleteOrder(),
      ),
      HomePageScreens(
        show: openData.report,
        id: 8,
        icon: Icons.add_chart,
        title: getText('reports'),
        screen: ReportPage(),
      ),
      HomePageScreens(
        show: openData.role == UserRole.admin,
        id: 9,
        icon: Icons.image,
        title: getText('search_banner'),
        screen: ShowSearchBanner(),
      ),
    ];
    screens = screens.where((element) => element.show).toList();
    currentScreen = screens[0];
  }

  void change(int index) {
    currentScreen = screens[index];
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
