import '../utils/currency.dart';

class KiaanAyurvedaBillItem {
  String? description;
  int? quantity;
  double? rate;
  String? hsnSac;

  KiaanAyurvedaBillItem({
    this.description,
    this.quantity,
    this.rate,
    this.hsnSac,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'rate': rate,
      'hsnSac': hsnSac,
    };
  }

  factory KiaanAyurvedaBillItem.fromMap(Map<String, dynamic> map) {
    return KiaanAyurvedaBillItem(
      description: map['description'],
      quantity: map['quantity'],
      rate: checkDouble(map['rate']),
      hsnSac: map['hsnSac'],
    );
  }

  double get amount => quantity != null && rate != null ? quantity! * rate! : 0;

  String get rateInRupees => rate!.inRupeesFormat();
  String get amountInRupees => amount.inRupeesFormat();
}

class KiaanAyurvedaBill {
  String? id;
  String invoiceNo;
  String invoiceDate;
  String to;
  String toAddress;
  String? toGst;
  String? toEmail;
  bool isGstBill;

  List<KiaanAyurvedaBillItem> items;

  KiaanAyurvedaBill({
    this.id,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.to,
    required this.toAddress,
    this.toGst,
    this.toEmail,
    this.items = const [],
    this.isGstBill = false,
  });

  void addItem(KiaanAyurvedaBillItem item) {
    items.add(item);
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceNo': invoiceNo,
      'invoiceDate': invoiceDate,
      'to': to,
      'toAddress': toAddress,
      if (toGst != null && toGst!.isNotEmpty) ...{
        'toGst': toGst,
      },
      if (toEmail != null && toEmail!.isNotEmpty) ...{
        'toEmail': toEmail,
      },
      'items': items.map((x) => x.toMap()).toList(),
      'isGstBill': isGstBill,
    };
  }

  factory KiaanAyurvedaBill.fromMap(Map<String, dynamic> map) {
    return KiaanAyurvedaBill(
      id: map['id'] ?? map['_id'] ?? '',
      invoiceNo: map['invoiceNo'],
      invoiceDate: map['invoiceDate'],
      to: map['to'],
      toAddress: map['toAddress'],
      toGst: map['toGst'],
      toEmail: map['toEmail'],
      items: List<KiaanAyurvedaBillItem>.from(
          map['items']?.map((x) => KiaanAyurvedaBillItem.fromMap(x))),
      isGstBill: map['isGstBill'] ?? false,
    );
  }

  double get totalAmount => items.fold(0, (prev, item) => prev + item.amount);

  double get cgst => totalAmount * 0.09;
  double get sgst => totalAmount * 0.09;
  double get totalTax => cgst + sgst;

  double get grandTotal => totalAmount + totalTax;

  String get totalAmountInRupees => totalAmount.inRupeesFormat();
  String get cgstInRupees => cgst.inRupeesFormat();
  String get sgstInRupees => sgst.inRupeesFormat();
  String get totalTaxInRupees => totalTax.inRupeesFormat();
  String get grandTotalInRupees => grandTotal.inRupeesFormat();

  String get total => isGstBill ? grandTotalInRupees : totalAmountInRupees;

  String get _amountInWords =>
      isGstBill ? grandTotal.inWords() : totalAmount.inWords();

  String get amountInWords => '$_amountInWords only';
}
