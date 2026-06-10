// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

Future<void> exportDashboardReport(
  Map<String, dynamic> data, {
  required String fileName,
}) async {
  final excel = Excel.createExcel();

  /// ================= Dashboard Sheet =================
  final dashboard = excel['Dashboard'];

  dashboard.appendRow([TextCellValue("Metric"), TextCellValue("Value")]);

  void addRow(String title, dynamic value) {
    dashboard.appendRow([TextCellValue(title), TextCellValue("${value ?? 0}")]);
  }

  addRow("Employees Count", data['count_emp']);
  addRow("Clients Count", data['count_client']);
  addRow("Goods Count", data['count_goods']);
  addRow("Departments Count", data['count_department']);
  addRow("Offers Count", data['count_offers']);
  addRow("Completed Orders", data['count_complete_order']);
  addRow("Refused Orders", data['count_refuse_order']);
  addRow("Total Income", data['total_income']);

  /// ================= Orders Sheet =================
  final ordersSheet = excel['Orders'];

  ordersSheet.appendRow([
    TextCellValue("Order ID"),
    TextCellValue("Time"),
    TextCellValue("User Name"),
    TextCellValue("Status"),
    TextCellValue("Total Price"),
    TextCellValue("Goods Count"),
  ]);

  List orders = data['orders'] ?? [];

  for (var order in orders) {
    ordersSheet.appendRow([
      TextCellValue("${order['id']}"),
      TextCellValue("${order['time']}"),
      TextCellValue("${order['user_name']}"),
      TextCellValue("${order['status_text']}"),
      TextCellValue("${order['total_price']}"),
      TextCellValue("${order['count_goods']}"),
    ]);
  }

  /// ================= Generate File =================
  final bytes = excel.encode();
  if (bytes == null) return;

  if (kIsWeb) {
    final blob = html.Blob([Uint8List.fromList(bytes)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", "$fileName.xlsx")
      ..click();

    html.Url.revokeObjectUrl(url);
  } else {
    final filePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Excel File',
      fileName: '$fileName.xlsx',
      allowedExtensions: ['xlsx'],
      type: FileType.custom,
    );

    if (filePath != null) {
      final file = File(
        filePath.endsWith('.xlsx') ? filePath : '$filePath.xlsx',
      );
      await file.writeAsBytes(bytes);
    }
  }
}
