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

class _ShowOffersState extends State<ShowOffers> {
  late ApplicationController<Offer> controller;

  @override
  void initState() {
    controller = .new();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        TEXT(text: getText('offer'), size: 25, bold: true),
        SizedBox(
          width: pageSizeWidth(context, 0.5),
          child: Row(
            crossAxisAlignment: .center,
            spacing: 12,
            mainAxisAlignment: .start,
            children: [
              Expanded(
                child: CustomField(
                  icon: Icons.search,
                  hintText: "${getText('name')} ....",
                  onChanged: (p0) {
                    controller.search(p0, (p1) => p1.goodName.toString());
                  },
                ),
              ),
              Expanded(
                child: CustomField(
                  icon: Icons.search,
                  hintText: "${getText('code')} ....",
                  onChanged: (p0) {
                    controller.search(p0, (p1) => p1.goodCode.toString());
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              CustomHeadTable(
                headData: [
                  CustomHeadTableItems(flex: 1, text: getText('num')),
                  CustomHeadTableItems(flex: 4, text: getText('good_name')),
                  CustomHeadTableItems(flex: 2, text: getText('code')),
                  CustomHeadTableItems(flex: 2, text: getText('offer_price')),
                  CustomHeadTableItems(flex: 2, text: getText('from')),
                  CustomHeadTableItems(flex: 2, text: getText('to')),

                  CustomHeadTableItems(flex: 1, text: getText('more')),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: OfferBase.getOffers(id: widget.id),
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
                      controller.equal(snapshot.data!.data);
                      return ShowOffersView(controller: controller);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
