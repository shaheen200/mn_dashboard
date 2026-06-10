class User {
  final int id;
  final int byId;
  final String name;
  final String phone;
  final bool isActive;
  final String time;
  final String address;
  final double salary;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.time,
    required this.address,
    required this.salary,
    required this.byId,
  });

  /// from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      byId: map['by_id'] ?? 0,
      name: map['name'],
      phone: map['phone'].toString(),
      isActive: map['is_active'] ?? false,
      time: map['time'].toString(),
      address: map['addres'],
      salary: (map['salary'] as num).toDouble(),
    );
  }

  /// to Map (اختياري)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'is_active': isActive,
      'time': time,
      'addres': address,
      'salary': salary,
      'by_id': byId,
    };
  }

  /// ✅ method تاخد List<dynamic> وترجع List<User>
  static List<User> fromList(List<dynamic> list) {
    return list.map((e) => User.fromMap(e as Map<String, dynamic>)).toList();
  }
}
