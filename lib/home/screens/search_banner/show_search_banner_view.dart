import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/banner_image_base.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/models/image_banner.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowSearchBannerView extends StatefulWidget {
  final ApplicationController<ImageBanner> controller;
  final bool isDesktop;
  const ShowSearchBannerView({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

  @override
  State<ShowSearchBannerView> createState() => _ShowSearchBannerViewState();
}

class _ShowSearchBannerViewState extends State<ShowSearchBannerView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
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
              ? CustomBodyTable(
                  bodyData: [
                    CustomBodyTableItems(
                      flex: 1,
                      widget: TEXT(text: "${index + 1}", bold: true, size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(item.url));
                        },
                        child: TEXT(
                          text: getText('tap_to_view'),
                          bold: true,
                          size: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: TEXT(text: "${item.time}", size: 15),
                    ),
                    CustomBodyTableItems(
                      flex: 2,
                      widget: Switch(
                        value: item.isActive,
                        onChanged: (value) async {
                          waiting(context: context);
                          final create = await BannerImageBase.edit(
                            id: item.id,
                            isActive: value,
                          );
                          pOP(context);
                          if (create.success) {
                            widget.controller.editItem(
                              create.data!,
                              (p0, p1) => p0.id == p1.id,
                            );
                          } else {
                            msgDialog(
                              context1: context,
                              state: -1,
                              text: create.msg,
                            );
                          }
                        },
                      ),
                    ),
                    CustomBodyTableItems(
                      flex: 1,
                      widget: CustomPop(
                        items: [
                          CustomPopItems(
                            text: getText('delete'),
                            icon: Icons.delete_rounded,
                            onTap: () async {
                              waiting(context: context);
                              final delete = await BannerImageBase.delete(
                                id: item.id,
                              );
                              pOP(context);
                              if (delete.success) {
                                widget.controller.delete(index);
                              }
                              msgDialog(
                                context1: context,
                                state: delete.success ? 1 : -1,
                                text: delete.msg,
                              );
                            },
                          ),
                          CustomPopItems(
                            text: getText('by'),
                            icon: Icons.person_outline_rounded,
                            onTap: () {
                              byIdDialog(context: context, id: item.byId);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : CustomContainer(
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
                                  size: 12,
                                  bold: true,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(Uri.parse(item.url));
                                },
                                child: TEXT(
                                  text: getText('tap_to_view'),
                                  bold: true,
                                  size: 15,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          CustomPop(
                            items: [
                              CustomPopItems(
                                text: getText('delete'),
                                icon: Icons.delete_rounded,
                                onTap: () async {
                                  waiting(context: context);
                                  final delete = await BannerImageBase.delete(
                                    id: item.id,
                                  );
                                  pOP(context);
                                  if (delete.success) {
                                    widget.controller.delete(index);
                                  }
                                  msgDialog(
                                    context1: context,
                                    state: delete.success ? 1 : -1,
                                    text: delete.msg,
                                  );
                                },
                              ),
                              CustomPopItems(
                                text: getText('by'),
                                icon: Icons.person_outline_rounded,
                                onTap: () {
                                  byIdDialog(context: context, id: item.byId);
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
                            Icons.calendar_today_rounded,
                            "${item.time}",
                          ),
                          Switch(
                            value: item.isActive,
                            onChanged: (value) async {
                              waiting(context: context);
                              final create = await BannerImageBase.edit(
                                id: item.id,
                                isActive: value,
                              );
                              pOP(context);
                              if (create.success) {
                                widget.controller.editItem(
                                  create.data!,
                                  (p0, p1) => p0.id == p1.id,
                                );
                              } else {
                                msgDialog(
                                  context1: context,
                                  state: -1,
                                  text: create.msg,
                                );
                              }
                            },
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
