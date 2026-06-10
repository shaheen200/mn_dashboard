class Order {
  final int id;
  final int userId;
  final String status;
  final String time;
  final String userName;
  final String statusText;
  final String note;
  final num totalPrice;
  final num countGoods;
  final String extraAddress;
  final String extraPhone;

  Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.time,
    required this.userName,
    required this.statusText,
    required this.totalPrice,
    required this.countGoods,
    required this.note,
    required this.extraPhone,
    required this.extraAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      time: json['time'],
      userName: json['user_name'],
      statusText: json['status_text'],
      note: json['note'] ?? '',
      totalPrice: num.parse(json['total_price'].toString()),
      countGoods: num.parse(json['count_goods'].toString()),
      extraAddress: "${json['extra_address']}".isEmpty
          ? 'لا يوجد'
          : "${json['extra_address']}",
      extraPhone: "${json['extra_phone']}".isEmpty
          ? 'لا يوجد'
          : json['extra_phone'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'time': time,
      'user_name': userName,
      'status_text': statusText,
      'total_price': totalPrice,
    };
  }

  static List<Order> fromList(List<dynamic> list) {
    return list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
  }
}
