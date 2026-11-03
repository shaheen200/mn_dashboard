import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/home/screens/empolyee/edit/edit_empolyee_dialog.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/models/user.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';

class ShowEmpolyeeView extends StatefulWidget {
  final ApplicationController<User> controller;
  final bool isDesktop;
  const ShowEmpolyeeView({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

  @override
  State<ShowEmpolyeeView> createState() => _ShowEmpolyeeViewState();
}

class _ShowEmpolyeeViewState extends State<ShowEmpolyeeView> {
  @override
  void initState() {
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.controller.items.length,
      itemBuilder: (context, index) {
        final item = widget.controller.items[index];

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 40).clamp(0, 400)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 15 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: widget.isDesktop
              ? // 🖥️ تصميم الجدول للشاشات الكبيرة (الويب)
                CustomBodyTable(
                  bodyData: [
                    CustomBodyTableItems(
                      flex: 1,
                      widget: TEXT(text: "${index + 1}", bold: true, size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 4,
                      widget: TEXT(text: "${item.name}", bold: true, size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.phone}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.address}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.time}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(
                        text: "${item.salary}",
                        bold: true,
                        size: 15,
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 1,
                      widget: CustomPop(
                        items: [
                          CustomPopItems(
                            text: getText('by'),
                            icon:
                                Icons.visibility_rounded, // أيقونة عرض التفاصيل
                            onTap: () {
                              byIdDialog(context: context, id: item.byId);
                            },
                          ),
                          CustomPopItems(
                            text: getText('edit'),
                            icon: Icons.edit_rounded, // أيقونة التعديل
                            onTap: () {
                              editEmpolyeeDialog(
                                context,
                                controller: widget.controller,
                                index: index,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : // 📱 تصميم البطاقات المودرن المخصص لشاشات الموبايل
                CustomContainer(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(16),
                  radius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                child: TEXT(
                                  text: "${index + 1}",
                                  size: 13,
                                  bold: true,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              TEXT(text: "${item.name}", size: 16, bold: true),
                            ],
                          ),
                          CustomPop(
                            items: [
                              CustomPopItems(
                                text: getText('by'),
                                icon: Icons
                                    .visibility_rounded, // أيقونة عرض التفاصيل
                                onTap: () {
                                  byIdDialog(context: context, id: item.byId);
                                },
                              ),
                              CustomPopItems(
                                text: getText('edit'),
                                icon: Icons.edit_rounded, // أيقونة التعديل
                                onTap: () {
                                  editEmpolyeeDialog(
                                    context,
                                    controller: widget.controller,
                                    index: index,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.phone_android_rounded,
                            "${item.phone}",
                          ),
                          _buildInfoRow(
                            context,
                            Icons.place_outlined,
                            "${item.address}",
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.calendar_today_rounded,
                            "${item.time}",
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TEXT(
                              text: "${item.salary} 💰",
                              size: 14,
                              bold: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: Theme.of(context).primaryColorDark.withOpacity(0.6),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).primaryColorDark.withOpacity(0.8),
            fontFamily: "tajawal",
          ),
        ),
      ],
    );
  }
}
