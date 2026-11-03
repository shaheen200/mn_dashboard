// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mn1/database/home__base.dart';
import 'package:mn1/models/api_data.dart';
import 'package:mn1/models/dashboard_model.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/container/custom_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late Future<ApiData<DashboardModel?>> _statsFuture;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _statsFuture = HomeBase.getDashboardStats();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<ApiData<DashboardModel?>>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.data!.success) {
                return Center(
                  child: TEXT(
                    text: snapshot.data?.msg ?? "حدث خطأ أثناء تحميل البيانات",
                    size: 18,
                    bold: true,
                  ),
                );
              }

              final stats = snapshot.data!.data!;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TEXT(
                              text: "لوحة التحكم المركزية",
                              size: isDesktop ? 28 : 22,
                              bold: true,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "مرحباً بك، نظرة تفصيلية على مؤشرات الأداء والتحليلات",
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).primaryColorDark.withOpacity(0.6),
                                fontFamily: "tajawal",
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _statsFuture = HomeBase.getDashboardStats();
                            });
                          },
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          tooltip: "تحديث البيانات",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // بطاقات الإحصائيات
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isDesktop ? 1.5 : 1.25,
                      children: [
                        _buildStatCard(
                          context,
                          "إجمالي الموظفين",
                          "${stats.empCount}",
                          Icons.badge_rounded,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          context,
                          "إجمالي العملاء",
                          "${stats.clientCount}",
                          Icons.people_alt_rounded,
                          Colors.teal,
                        ),
                        _buildStatCard(
                          context,
                          "منتجات المخزن",
                          "${stats.goodsCount}",
                          Icons.inventory_2_rounded,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          context,
                          "الأقسام المتاحة",
                          "${stats.departmentCount}",
                          Icons.category_rounded,
                          Colors.purple,
                        ),
                        _buildStatCard(
                          context,
                          "إجمالي الطلبات",
                          "${stats.ordersCount}",
                          Icons.shopping_cart_rounded,
                          Colors.indigo,
                        ),
                        _buildStatCard(
                          context,
                          "إجمالي الأرباح",
                          "${stats.totalRevenue} 💰",
                          Icons.monetization_on_rounded,
                          Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // قسم منحنى الطلبيات المكتملة على مدار الشهر (محور X و Y)
                    TEXT(
                      text: "إحصائيات الطلبيات المكتملة خلال الشهر",
                      size: 20,
                      bold: true,
                    ),
                    const SizedBox(height: 16),
                    _buildLineChartCard(context, stats.monthlyOrders),
                    const SizedBox(height: 30),

                    // الرسوم البيانية الأخرى (أعمدة ودائري)
                    isDesktop
                        ? Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildBarChartCard(context, stats),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 2,
                                child: _buildPieChartCard(context, stats),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildBarChartCard(context, stats),
                              const SizedBox(height: 20),
                              _buildPieChartCard(context, stats),
                            ],
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              Icon(Icons.trending_up_rounded, color: color, size: 18),
            ],
          ),
          const Spacer(),
          TEXT(text: value, size: 20, bold: true),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).primaryColorDark.withOpacity(0.6),
              fontFamily: "tajawal",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // رسم بياني خطي (Line Chart) للطلبيات المكتملة لجميع أيام الشهر (الأيام الخالية بقيمة صفر)
  Widget _buildLineChartCard(
    BuildContext context,
    List<MonthlyOrderPoint> points,
  ) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    Map<int, double> ordersMap = {
      for (var e in points) e.day: e.count.toDouble(),
    };

    List<FlSpot> spots = List.generate(daysInMonth, (index) {
      int day = index + 1;
      double count = ordersMap[day] ?? 0.0;
      return FlSpot(day.toDouble(), count);
    });

    return CustomContainer(
      padding: const EdgeInsets.all(20),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TEXT(
                text: "منحنى الطلبيات المكتملة (أيام الشهر)",
                size: 16,
                bold: true,
              ),
              Icon(
                Icons.show_chart_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: daysInMonth.toDouble(),
                minY: 0,
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'يوم ${value.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'tajawal',
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(BuildContext context, DashboardModel stats) {
    return CustomContainer(
      padding: const EdgeInsets.all(20),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TEXT(text: "معدل العناصر والكيانات", size: 16, bold: true),
          const SizedBox(height: 25),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    [
                      stats.empCount,
                      stats.clientCount,
                      stats.goodsCount,
                      stats.departmentCount,
                      stats.ordersCount,
                    ].reduce((a, b) => a > b ? a : b).toDouble() +
                    5,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = [
                          'موظفين',
                          'عملاء',
                          'منتجات',
                          'أقسام',
                          'طلبات',
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < titles.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              titles[value.toInt()],
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'tajawal',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: stats.empCount.toDouble(),
                        color: Colors.blue,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: stats.clientCount.toDouble(),
                        color: Colors.teal,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: stats.goodsCount.toDouble(),
                        color: Colors.orange,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: stats.departmentCount.toDouble(),
                        color: Colors.purple,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: stats.ordersCount.toDouble(),
                        color: Colors.indigo,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard(BuildContext context, DashboardModel stats) {
    return CustomContainer(
      padding: const EdgeInsets.all(20),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TEXT(text: "نسب التوزيع التفاعلية", size: 16, bold: true),
          const SizedBox(height: 15),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: stats.empCount.toDouble(),
                    title: '${stats.empCount}',
                    radius: touchedIndex == 0 ? 55 : 48,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.teal,
                    value: stats.clientCount.toDouble(),
                    title: '${stats.clientCount}',
                    radius: touchedIndex == 1 ? 55 : 48,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.orange,
                    value: stats.goodsCount.toDouble(),
                    title: '${stats.goodsCount}',
                    radius: touchedIndex == 2 ? 55 : 48,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.purple,
                    value: stats.departmentCount.toDouble(),
                    title: '${stats.departmentCount}',
                    radius: touchedIndex == 3 ? 55 : 48,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
