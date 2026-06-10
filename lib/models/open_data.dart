enum UserRole { admin, emp, client }

class OpenData {
  OpenData({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.address,
    required this.role,
    required this.showEmp,
    required this.addEmp,
    required this.showClient,
    required this.addClient,
    required this.showDepart,
    required this.addDepart,
    required this.showStore,
    required this.addGood,
    required this.showOffer,
    required this.addOffer,
    required this.showCompleteOrder,
    required this.showNotCompleteOrder,
    required this.report,
  });

  factory OpenData.fromMap(Map<String, dynamic> map) {
    final isAdmin = map['role'] == 'admin';

    bool permission(dynamic value) {
      if (isAdmin) return true;
      return value == true;
    }

    return OpenData(
      id: map['id'] as int,
      name: map['name'].toString(),
      phone: map['phone'].toString(),
      isActive: map['is_active'] as bool,
      address: map['addres'] as String,
      role: map['role'] == 'admin'
          ? UserRole.admin
          : map['role'] == 'emp'
          ? UserRole.emp
          : UserRole.client,
      showEmp: permission(map['show_emp']),
      addEmp: permission(map['add_emp']),
      showClient: permission(map['show_client']),
      addClient: permission(map['add_client']),
      showDepart: permission(map['show_depart']),
      addDepart: permission(map['add_depart']),
      showStore: permission(map['show_store']),
      addGood: permission(map['add_good']),
      showOffer: permission(map['show_offer']),
      addOffer: permission(map['add_offer']),
      showCompleteOrder: permission(map['show_complete_order']),
      showNotCompleteOrder: permission(map['show_not_complete_order']),
      report: permission(map['report']),
    );
  }
  final int id;
  final String name;
  final String phone;
  final bool isActive;
  final String? address;
  final UserRole role;

  final bool showEmp;
  final bool addEmp;
  final bool showClient;
  final bool addClient;
  final bool showDepart;
  final bool addDepart;
  final bool showStore;
  final bool addGood;
  final bool showOffer;
  final bool addOffer;
  final bool showCompleteOrder;
  final bool showNotCompleteOrder;
  final bool report;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'is_active': isActive,
      'addres': address,
      'role': role,
      'show_emp': showEmp,
      'add_emp': addEmp,
      'show_client': showClient,
      'add_client': addClient,
      'show_depart': showDepart,
      'add_depart': addDepart,
      'show_store': showStore,
      'add_good': addGood,
      'show_offer': showOffer,
      'add_offer': addOffer,
      'show_complete_order': showCompleteOrder,
      'show_not_complete_order': showNotCompleteOrder,
      'report': report,
    };
  }
}
