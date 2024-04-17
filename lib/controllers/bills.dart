import 'package:dio/dio.dart';

import '../constants/url.dart';
import '../models/bill.dart';

class BillsController {
  static _getDio() {
    assert(API_URL.isNotEmpty,
        'API_URL is not set. Please set it in lib/constants/url.dart');
    return Dio(BaseOptions(baseUrl: API_URL));
  }

  static int? newBillNo;
  static List<String> toList = [];
  static List<String> toAddressList = [];
  static List<String> toGstList = [];
  static List<String> toEmailList = [];

  static void _initializeVariables(List<KiaanAyurvedaBill> bills) {
    try {
      String lastInvoiceNoStr = bills[0].invoiceNo;
      int lastInvoiceNo = int.parse(lastInvoiceNoStr);
      newBillNo = lastInvoiceNo + 1;
    } catch (e) {
      print(e);
    }

    for (var bill in bills) {
      if (toList.contains(bill.to)) {
        continue;
      }

      toList.add(bill.to);
      toAddressList.add(bill.toAddress);
      toGstList.add(bill.toGst ?? '');
      toEmailList.add(bill.toEmail ?? '');
    }
  }

  static Future<List<KiaanAyurvedaBill>?> getBills() async {
    try {
      final response = await _getDio().get('/bills');

      final List<KiaanAyurvedaBill> bills = (response.data as List)
          .map((bill) => KiaanAyurvedaBill.fromMap(bill))
          .toList();

      _initializeVariables(bills);

      return bills;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<KiaanAyurvedaBill?> createBill(KiaanAyurvedaBill bill) async {
    try {
      final response = await _getDio().post('/bills', data: bill.toMap());

      return KiaanAyurvedaBill.fromMap(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<KiaanAyurvedaBill?> updateBill(KiaanAyurvedaBill bill) async {
    try {
      final response =
          await _getDio().put('/bills/${bill.id}', data: bill.toMap());

      return KiaanAyurvedaBill.fromMap(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> deleteBill(String id) async {
    try {
      await _getDio().delete('/bills/$id');

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
