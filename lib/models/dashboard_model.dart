class MonthlyOrderPoint {
  final int day;
  final int count;

  MonthlyOrderPoint({required this.day, required this.count});

  factory MonthlyOrderPoint.fromMap(Map<String, dynamic> map) {
    return MonthlyOrderPoint(
      day: int.parse(map['day'].toString()),
      count: int.parse(map['count'].toString()),
    );
  }
}

class DashboardModel {
  final int empCount;
  final int clientCount;
  final int goodsCount;
  final int departmentCount;
  final int ordersCount;
  final double totalRevenue;
  final List<MonthlyOrderPoint> monthlyOrders;

  DashboardModel({
    required this.empCount,
    required this.clientCount,
    required this.goodsCount,
    required this.departmentCount,
    required this.ordersCount,
    required this.totalRevenue,
    required this.monthlyOrders,
  });

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    var rawList = map['monthly_orders'] as List? ?? [];
    List<MonthlyOrderPoint> ordersList = rawList
        .map((e) => MonthlyOrderPoint.fromMap(e))
        .toList();

    return DashboardModel(
      empCount: map['emp_count'] ?? 0,
      clientCount: map['client_count'] ?? 0,
      goodsCount: map['goods_count'] ?? 0,
      departmentCount: map['department_count'] ?? 0,
      ordersCount: map['orders_count'] ?? 0,
      totalRevenue: double.parse(map['total_revenue'].toString()),
      monthlyOrders: ordersList,
    );
  }
}
