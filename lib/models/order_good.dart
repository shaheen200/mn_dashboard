class OrderGood {
  final int id;
  final int orderId;
  final int goodId;
  final num price;
  final num count;
  final String time;
  final num totalPrice;
  final String goodName;
  final String departName;

  OrderGood({
    required this.id,
    required this.orderId,
    required this.goodId,
    required this.price,
    required this.count,
    required this.time,
    required this.totalPrice,
    required this.goodName,
    required this.departName,
  });

  factory OrderGood.fromJson(Map<String, dynamic> json) {
    return OrderGood(
      id: json['id'],
      orderId: json['order_id'],
      goodId: json['good_id'],
      price: num.parse(json['price'].toString()),
      count: num.parse(json['count'].toString()),
      time: json['time'],
      totalPrice: num.parse(json['total_price'].toString()),
      goodName: json['good_name'] ?? '',
      departName: json['depart_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'good_id': goodId,
      'price': price,
      'count': count,
      'time': time,
      'total_price': totalPrice,
      'good_name': goodName,
      'depart_name': departName,
    };
  }

  static List<OrderGood> fromList(List<dynamic> list) {
    return list
        .map((e) => OrderGood.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
