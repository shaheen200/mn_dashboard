import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mn1/database/report_base.dart';
import 'package:mn1/home/screens/reports/create_excel_report.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_btn/custom_btn_date_between.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String startDate = DateTime.now()
      .subtract(Duration(days: 4))
      .toString()
      .split(' ')[0];
  String endDate = DateTime.now()
      .add(Duration(days: 2))
      .toString()
      .split(' ')[0];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReportBase.report(startDate: startDate, endDate: endDate),
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
          final listOrder = snapshot.data!.data['orders'] as List;
          return Column(
            crossAxisAlignment: .start,
            spacing: 20,
            children: [
              TEXT(text: getText('reports'), size: 25, bold: true),
              Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .start,
                spacing: 15,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 8,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: TEXT(
                      text: 'من ${startDate} الي تاريخ ${endDate}',
                      size: 17,
                      bold: true,
                    ),
                  ),
                  CustomBtnDateBetween(
                    onselect: (p0, p1) {
                      setState(() {
                        startDate = p0;
                        endDate = p1;
                      });
                    },
                  ),
                  const Spacer(),
                  CustomBtn(
                    onClick: () async {
                      await exportDashboardReport(
                        snapshot.data!.data,
                        fileName: 'report',
                      );
                    },
                    text: 'تصدير Excel',
                    w: 0.2,
                    raduis: 5,
                  ),
                ],
              ),
              IntrinsicHeight(
                child: Row(
                  spacing: 15,
                  crossAxisAlignment: .stretch,
                  children: [
                    Expanded(
                      child: _con(
                        icon: Icons.people,
                        title: 'الموظفين',
                        value: snapshot.data!.data['count_emp'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _con(
                        icon: Icons.people_alt_outlined,
                        title: 'العملاء',
                        value: snapshot.data!.data['count_client'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _con(
                        icon: Icons.store,
                        title: 'المخزون',
                        value: snapshot.data!.data['count_goods'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _con(
                        icon: Icons.local_fire_department_outlined,
                        title: 'الاقسام',
                        value: snapshot.data!.data['count_department']
                            .toString(),
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  spacing: 15,
                  crossAxisAlignment: .stretch,
                  children: [
                    Expanded(
                      child: _con(
                        icon: Icons.local_offer_outlined,
                        title: 'العروض',
                        value: snapshot.data!.data['count_offers'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _con(
                        icon: Icons.monetization_on,
                        title: 'اجمالي المبيعات',
                        value: snapshot.data!.data['total_income'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _con(
                        icon: Icons.shopping_cart_outlined,
                        title: 'الطلبيات المكتملة',
                        value: snapshot.data!.data['count_complete_order']
                            .toString(),
                      ),
                    ),
                    Expanded(
                      child: _con(
                        icon: Icons.shopping_cart,
                        title: 'الطلبيات المرفوضة',
                        value: snapshot.data!.data['count_refuse_order']
                            .toString(),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  TEXT(text: 'جدول تفصيلي للطلبات', size: 25, bold: true),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).primaryColorDark,
                      endIndent: 15,
                      indent: 15,
                      height: 10,
                    ),
                  ),
                ],
              ),
              CustomHeadTable(
                headData: [
                  CustomHeadTableItems(flex: 1, text: 'رقم الطلب'),
                  CustomHeadTableItems(flex: 1, text: 'التاريخ'),
                  CustomHeadTableItems(flex: 1, text: 'العميل'),
                  CustomHeadTableItems(flex: 1, text: 'الحالة'),
                  CustomHeadTableItems(flex: 1, text: 'القيمة'),
                  CustomHeadTableItems(flex: 1, text: 'عدد الاصناف'),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listOrder.length,
                  itemBuilder: (context, index) {
                    return CustomBodyTable(
                      bodyData: [
                        CustomBodyTableItems(
                          flex: 1,
                          widget: TEXT(
                            text: "${listOrder[index]['id']}",
                            size: 17,
                          ),
                        ),
                        CustomBodyTableItems(
                          flex: 1,
                          widget: TEXT(
                            text: "${listOrder[index]['time']}".split('T')[0],
                            size: 17,
                          ),
                        ),
                        CustomBodyTableItems(
                          flex: 1,
                          widget: TEXT(
                            text: "${listOrder[index]['user_name']}",
                            size: 17,
                          ),
                        ),
                        CustomBodyTableItems(
                          flex: 1,
                          widget: Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 4,
                              bottom: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  "${listOrder[index]['status_text']}" ==
                                      "تم التاكيد"
                                  ? Colors.green.shade400
                                  : Colors.red.shade400,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TEXT(
                              text: "${listOrder[index]['status_text']}",
                              size: 17,
                            ),
                          ),
                        ),
                        CustomBodyTableItems(
                          flex: 1,
                          widget: TEXT(
                            text: "${listOrder[index]['total_price']}",
                            size: 17,
                          ),
                        ),
                        CustomBodyTableItems(
                          flex: 1,
                          widget: TEXT(
                            text: "${listOrder[index]['count_goods']}",
                            size: 17,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _con({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _listColor[math.Random().nextInt(_listColor.length)],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 10,
        children: [
          TEXT(text: title, size: 22, bold: true, color: Colors.white),

          Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .start,
            spacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              Expanded(
                child: TEXT(text: value, size: 20, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final List<Color> _listColor = [
  Colors.red,
  Colors.redAccent,
  Colors.blueGrey,
  Colors.blue,
  Colors.brown,
  Colors.teal,
  Colors.pink,
  Colors.black,
  Colors.purple,
  Colors.deepOrange,
  Colors.deepPurple,
];
