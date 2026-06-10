class Good {
  final int id;
  final String name;
  final int code;
  final String price;
  final String exist;
  final String time;
  final bool isActive;
  final int byId;
  final int? departmentId;
  final String? departmentName;

  Good({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.exist,
    required this.time,
    required this.isActive,
    required this.byId,
    this.departmentId,
    this.departmentName,
  });

  factory Good.fromMap(Map<String, dynamic> json) {
    return Good(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as int,
      price: json['price'].toString(),
      exist: json['exist'].toString(),
      time: json['time'].toString(),
      isActive: json['is_active'] as bool,
      byId: json['by_id'] as int,
      departmentId: json['department_id'],
      departmentName: json['department_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'price': price,
      'exist': exist,
      'time': time,
      'is_active': isActive,
      'by_id': byId,
      'department_id': departmentId,
      'department_name': departmentName,
    };
  }

  static List<Good> fromList(List<dynamic> list) {
    return list.map((e) => Good.fromMap(e as Map<String, dynamic>)).toList();
  }
}
