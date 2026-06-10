import 'package:flutter/material.dart';

class ApplicationController<T> extends ChangeNotifier {
  List<T> _list = [];
  List<T> _filteredList = [];
  bool _isSearching = false; // ✅ لتتبع حالة البحث

  /// ✅ يرجع العناصر المطلوبة بناءً على البحث
  List<T> get items => _filteredList.isEmpty && _isSearching
      ? []
      : (_filteredList.isNotEmpty ? _filteredList : _list);

  void addItem(T data) {
    _list.add(data);
    notifyListeners();
  }

  void equal(List<T> data) {
    _list = data;
    _filteredList = [];
    _isSearching = false;
    notifyListeners();
  }

  /// ✅ البحث العادي
  void search(String p0, String Function(T p0) get) {
    _isSearching = p0.isNotEmpty;

    if (p0.isEmpty) {
      _filteredList = [];
    } else {
      _filteredList = _list.where((item) {
        final name = get(item).toLowerCase();
        return name.contains(p0.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// ✅ البحث بين قيمتين
  void searchBetween(
    String p0,
    String p1,
    String Function(T p0) get,
    String Function(T p1) get2,
  ) {
    _isSearching = p0.isNotEmpty || p1.isNotEmpty;

    if (!_isSearching) {
      _filteredList = [];
    } else {
      _filteredList = _list.where((item) {
        final data = get(item).toLowerCase();
        final data2 = get2(item).toLowerCase();
        return data.contains(p0.toLowerCase()) &&
            data2.contains(p1.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void editItem(T updatedItem, bool Function(T p0, T p1) areEqual) {
    final index = _list.indexWhere((item) => areEqual(item, updatedItem));
    if (index != -1) {
      _list[index] = updatedItem;

      final filteredIndex = _filteredList.indexWhere(
        (item) => areEqual(item, updatedItem),
      );
      if (filteredIndex != -1) {
        _filteredList[filteredIndex] = updatedItem;
      }
      notifyListeners();
    }
  }

  void delete(int index) {
    if (index >= 0 && index < _list.length) {
      final itemToRemove = _list[index];
      _list.removeAt(index);
      _filteredList.removeWhere((item) => item == itemToRemove);
      notifyListeners();
    }
  }
}
