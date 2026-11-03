import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/offer_base.dart';
import 'package:mn1/home/screens/offers/show/show_offers_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/offer.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowOffers extends StatefulWidget {
  final int id;
  const ShowOffers({super.key, this.id = 0});

  @override
  State<ShowOffers> createState() => _ShowOffersState();
}

class _ShowOffersState extends State<ShowOffers>
    with SingleTickerProviderStateMixin {
  late ApplicationController<Offer> controller;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    controller = ApplicationController<Offer>();
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TEXT(
            text: getText('offer'),
            size: isDesktop ? 26 : 22,
            bold: true,
            color: Theme.of(context).primaryColorDark,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: isDesktop ? pageSizeWidth(context, 0.5) : double.infinity,
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(child: _buildSearchFields()[0]),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSearchFields()[1]),
                    ],
                  )
                : Column(
                    children: [
                      _buildSearchFields()[0],
                      const SizedBox(height: 12),
                      _buildSearchFields()[1],
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                if (isDesktop)
                  CustomHeadTable(
                    headData: [
                      CustomHeadTableItems(flex: 1, text: getText('num')),
                      CustomHeadTableItems(flex: 4, text: getText('good_name')),
                      CustomHeadTableItems(flex: 2, text: getText('code')),
                      CustomHeadTableItems(
                        flex: 2,
                        text: getText('offer_price'),
                      ),
                      CustomHeadTableItems(flex: 2, text: getText('from')),
                      CustomHeadTableItems(flex: 2, text: getText('to')),
                      CustomHeadTableItems(flex: 1, text: getText('more')),
                    ],
                  ),
                if (isDesktop) const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder(
                    future: OfferBase.getOffers(id: widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!.success) {
                        return Center(
                          child: TEXT(
                            text:
                                snapshot.data?.msg ?? "حدث خطأ في تحميل العروض",
                            size: 18,
                            bold: true,
                            center: true,
                          ),
                        );
                      } else {
                        controller.equal(snapshot.data!.data);
                        return ShowOffersView(
                          controller: controller,
                          isDesktop: isDesktop,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchFields() {
    return [
      CustomField(
        icon: Icons.search_rounded,
        hintText: "${getText('name')} ....",
        onChanged: (p0) {
          controller.search(p0, (p1) => p1.goodName.toString());
        },
      ),
      CustomField(
        icon: Icons.numbers_rounded,
        hintText: "${getText('code')} ....",
        onChanged: (p0) {
          controller.search(p0, (p1) => p1.goodCode.toString());
        },
      ),
    ];
  }
}
