class Department {
  final int id;
  final String name;
  final String image;
  final String time;
  final bool isActive;
  final int byId;

  Department({
    required this.id,
    required this.name,
    required this.image,
    required this.time,
    required this.isActive,
    required this.byId,
  });

  /// from Map (API / DB)
  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'],
      byId: map['by_id'],
      name: map['name'],
      image: map['image'] ?? '',
      time: map['time'].toString(),
      isActive: map['is_active'] ?? false,
    );
  }

  /// to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'time': time,
      'is_active': isActive,
      'by_id': byId,
    };
  }

  /// ✅ take List<dynamic> and return List<Department>
  static List<Department> fromList(List<dynamic> list) {
    return list
        .map((e) => Department.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
