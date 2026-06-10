class Offer {
  final int id;
  final int goodId;
  final String price;
  final String time;
  final bool isActive;
  final int byId;
  final String fromDate;
  final String toDate;
  final String goodName;
  final int goodCode;

  Offer({
    required this.id,
    required this.goodId,
    required this.price,
    required this.time,
    required this.isActive,
    required this.byId,
    required this.fromDate,
    required this.toDate,
    required this.goodName,
    required this.goodCode,
  });

  factory Offer.fromMap(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as int,
      goodId: json['good_id'] as int,
      price: json['price'],
      time: json['time'].toString(),
      isActive: json['is_active'] as bool,
      byId: json['by_id'] as int,
      fromDate: json['from_date'].toString(),
      toDate: json['to_date'].toString(),
      goodName: json['good_name'] as String,
      goodCode: json['good_code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'good_id': goodId,
      'price': price,
      'time': time,
      'is_active': isActive,
      'by_id': byId,
      'from_date': fromDate,
      'to_date': toDate,
      'good_name': goodName,
      'good_code': goodCode,
    };
  }

  static List<Offer> fromList(List<dynamic> list) {
    return list.map((e) => Offer.fromMap(e as Map<String, dynamic>)).toList();
  }
}
